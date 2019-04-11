//
//  PasscodeTextField.swift
//  Test
//
//  Created by 清水 脩輔 on 2019/04/11.
//  Copyright © 2019 清水 脩輔. All rights reserved.
//

import UIKit

protocol PasscodeTextFieldDelegate {
    // Deleteボタンを押した時の処理
    func didDeleteBackward(_ textField: PasscodeTextField)
}

class PasscodeTextField: UITextField {
    var delegatePasscode: PasscodeTextFieldDelegate?
    
    // 入力カーソル非表示
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    // 範囲選択カーソル非表示
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    
    // コピー・ペースト・選択等のメニュー非表示
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    // Deleteボタンを押した時の処理
    override func deleteBackward() {
        super.deleteBackward()
        delegatePasscode?.didDeleteBackward(self)
    }
}
