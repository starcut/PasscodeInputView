//
//  PassCodeView.swift
//  Test
//
//  Created by 清水 脩輔 on 2019/04/10.
//  Copyright © 2019 清水 脩輔. All rights reserved.
//

import UIKit

protocol PasscodeViewDelegate {
    // 正しいパスコードが入力された時に行う処理
    func successCompletion()
    // 間違ったパスコードが入力された時に行う処理
    func failCompletion()
}

extension PasscodeViewDelegate {
    // 正しいパスコードが入力された時に行う処理
    func successCompletion() {
        // デフォルトの処理としては何も行わない
        return
    }
    
    // 間違ったパスコードが入力された時に行う処理
    func failCompletion() {
        // デフォルトの処理としては何も行わない
        return
    }
}

class PasscodeView: UIView, UITextFieldDelegate, PasscodeTextFieldDelegate {
    // パスコードを並べて表示するView
    @IBOutlet weak private var passCodeStackView: UIStackView!
    // delegate
    var delegate: PasscodeViewDelegate?
    // 正しいパスワード
    var rightPasscode: String!
    // パスコード入力欄を格納した配列
    var passcodeTextFieldArray: [PasscodeTextField] = []
    
    //MARK: ****************** Initialize Method ******************
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    /**
     *  共通の初期化処理
     */
    fileprivate func commonInit() {
        guard let view = UINib(nibName: String(describing: type(of: self)), bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    //MARK: ****************** Public Method ******************
    
    /**
     * パスコードのビューの設定を行う
     *
     * - parameter rightPasscode: 正しいパスワード
     */
    public func setPassCodeView(rightPasscode: String) {
        self.rightPasscode = rightPasscode
        // 正しいパスワードが設定されていない場合は正しく入力できたとして処理を進める
        if self.rightPasscode.count == 0 {
            self.delegate?.successCompletion()
            return
        }
        
        // ここにパスコードの長さ分のテキストフィールドを設置する
        for i in 1 ... self.rightPasscode.count {
            let passcodeTextField: PasscodeTextField = PasscodeTextField.init()
            passcodeTextField.delegate = self
            passcodeTextField.delegatePasscode = self
            passcodeTextField.backgroundColor = UIColor.white
            passcodeTextField.borderStyle = .bezel
            passcodeTextField.clearsOnBeginEditing = true
            passcodeTextField.font = UIFont.systemFont(ofSize: 25.0)
            passcodeTextField.isSecureTextEntry = true
            passcodeTextField.keyboardType = .numberPad
            passcodeTextField.textAlignment = .center
            passcodeTextField.tag = i
            passcodeTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
            self.passcodeTextFieldArray.append(passcodeTextField)
            self.passCodeStackView.addArrangedSubview(passcodeTextField)
        }
        self.passcodeTextFieldArray.first?.becomeFirstResponder()
    }
    
    /**
     * テキスト入力後の処理
     * - parameter textField: 入力を行なったテキストフィールド
     */
    @objc private func textFieldDidChange(textField: PasscodeTextField) {
        // 最後のテキストフィールドに入力された時に正誤判定を行う
        if textField.tag == self.passcodeTextFieldArray.count {
            self.judgePasscode(textField: textField)
            return
        }
        // 次のテキストフィールドにフォーカスを移す
        let nextTextField: PasscodeTextField = self.passcodeTextFieldArray[textField.tag]
        nextTextField.becomeFirstResponder()
    }
    
    /**
     * パスコード正誤判定処理
     *
     * - parameter textField: 現在フォーカスが当たっているテキストフィールド
     */
    private func judgePasscode(textField: PasscodeTextField) {
        // 入力されたパスコードの文字列を作成する
        var inputPasscode: String = ""
        for passcodeTextField in self.passcodeTextFieldArray {
            inputPasscode.append(passcodeTextField.text!)
        }
        
        // パスコードの正誤判定とその結果による処理を行う
        if inputPasscode == self.rightPasscode {
            textField.resignFirstResponder()
            self.inputRightPasscode()
        } else {
            self.inputWrongPasscode()
        }
    }
    
    /**
     * 正しいパスコードが入力された時の処理
     */
    private func inputRightPasscode() {
        // 入力ができないようにする
        for textField in self.passcodeTextFieldArray {
            textField.isEnabled = false
            textField.backgroundColor = UIColor.lightGray
        }
        // 正しいパスコードが入力された後に行う処理を呼び出し元で行う
        self.delegate?.successCompletion()
    }
    
    /**
     * 間違ったパスコードが入力された時の処理
     *
     * - parameter textField: 現在フォーカスが当たっているテキストフィールド
     */
    private func inputWrongPasscode() {
        // 全ての入力内容をクリアする
        for passcodeTextField in self.passcodeTextFieldArray {
            passcodeTextField.text = ""
        }
        // フォーカスを最初のテキストフィールドに戻す
        self.passcodeTextFieldArray[0].becomeFirstResponder()
        
        // 正しいパスコードが入力された後に行う処理を呼び出し元で行う
        self.delegate?.failCompletion()
    }
    
    //MARK: ****************** PasscodeTextFieldDelegate ******************
    
    /**
     * Deleteボタンをタップした時にテキストフィールドに何も入力されていなければ一つ前のテキストフィールドにフォーカスを当てる
     */
    func didDeleteBackward(_ textField: PasscodeTextField) {
        if textField.tag > 1 {
            self.passcodeTextFieldArray[textField.tag - 2].becomeFirstResponder()
        }
    }
}
