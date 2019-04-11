# PasscodeInputView

パスコード画面を表示する

以下のように呼び出す

```
// frameを設定して初期化
let passcodeView : PasscodeView = PasscodeView.init(frame: frame)
// パスワード入力後のメソッド実行のためデリゲートを設定
passcodeView.delegate = self
// 正しいパスコードと、レイアウトを設定する
passcodeView.setPassCodeView(rightPasscode: "000000000")
// xibファイルで設置したViewにaddする
self.passcodeBaseView.addSubview(passcodeView)
```
