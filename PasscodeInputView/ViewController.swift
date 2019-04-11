//
//  ViewController.swift
//  Test
//
//  Created by 清水 脩輔 on 2019/04/10.
//  Copyright © 2019 清水 脩輔. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PasscodeViewDelegate {
    @IBOutlet weak private var passcodeBaseView : UIView!
    // エラーラベル
    @IBOutlet weak private var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.registerNotification()
        
        var frame: CGRect = self.passcodeBaseView.bounds
        frame.size.width = self.view.frame.width
        let passcodeView : PasscodeView = PasscodeView.init(frame: frame)
        passcodeView.delegate = self
        passcodeView.setPassCodeView(rightPasscode: "000000000")
        self.passcodeBaseView.addSubview(passcodeView)
    }
    
    func successCompletion() {
        self.errorLabel.isHidden = true
        
        for subview in self.passcodeBaseView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func failCompletion() {
        self.errorLabel.text = "パスコードが違います"
        self.errorLabel.isHidden = false
    }
    
    private func registerNotification() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                 name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                 name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// キーボードが表示時に画面をずらす。
    @objc func keyboardWillShow(_ notification: Notification?) {
        guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            let y: CGFloat = self.view.frame.height - (self.passcodeBaseView.frame.origin.y + self.passcodeBaseView.frame.height) - rect.size.height
            let transform = CGAffineTransform(translationX: 0, y: y)
            self.view.transform = transform
        }
    }
    
    /// キーボードが降りたら画面を戻す
    @objc func keyboardWillHide(_ notification: Notification?) {
        guard let duration = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
    }
}

