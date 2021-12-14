import UIKit

internal class SecureContentPreservingUITextField: UITextField {
    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        let cursorRange = self.selectedTextRange
        let success = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
            self.text = text
        }
        self.selectedTextRange = cursorRange
        return success
    }
}
