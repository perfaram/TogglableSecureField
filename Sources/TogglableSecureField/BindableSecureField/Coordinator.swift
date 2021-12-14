import SwiftUI

extension BindableSecureField.ViewRepresentable {
    internal final class Coordinator: NSObject, UITextFieldDelegate {
        internal let backingTextField: SecureContentPreservingUITextField
        private var parent: BindableSecureField.ViewRepresentable
        
        private var lastContent: String
        private var onCommit: BindableSecureField.Completion
        
        init(parent: BindableSecureField.ViewRepresentable,
             label: String,
             onCommit: @escaping BindableSecureField.Completion)
        {
            let textField = SecureContentPreservingUITextField(frame: .zero)
            
            // Regular settings to make this field a password field
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.keyboardType = .default
            textField.textContentType = .password
            textField.returnKeyType = .done
            
            // If using monospace font, without this the textField will grow, grow, grow
            // unboundedly in the horizontal direction to fit its content
            textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            // Match SwiftUI's (Secure)TextField accessibility features
            textField.isAccessibilityElement = true
            textField.accessibilityLabel = label
            textField.accessibilityIdentifier = label
                
            self.backingTextField = textField
            self.onCommit = onCommit
            self.lastContent = parent.secureContent.wrappedValue
            self.parent = parent
            
            super.init()
            
            self.backingTextField.delegate = self
        }
        
        func update(content: String,
                    showPassword: Bool,
                    useMonospaced: Bool)
        {
            let shouldBeSecureEntry = !showPassword
            if shouldBeSecureEntry != backingTextField.isSecureTextEntry {
                backingTextField.isSecureTextEntry = shouldBeSecureEntry
            }
            
            if useMonospaced {
                backingTextField.font = UIFont.monospacedSystemFont(
                    ofSize: backingTextField.font!.pointSize,
                    weight: UIFont.Weight.regular)
            }
            else {
                backingTextField.font = UIFont.systemFont(ofSize: backingTextField.font!.pointSize)
            }
            
            if content != lastContent {
                backingTextField.text = content
            }
        }
        
        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool
        {
            guard let oldText = textField.text, let textRange = Range(range, in: oldText) else {
                return false
            }

            lastContent = oldText.replacingCharacters(in: textRange, with: string)
            parent.secureContent.wrappedValue = lastContent

            return true
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // force the field to revert to a secure text field
            textField.isSecureTextEntry = true
            parent.showContent.wrappedValue = false
            
            // resigns first responder and dismiss keyboard
            textField.endEditing(true)
            
            onCommit()
            return false // prevent inserting carriage return or triggering the primary action
        }
    }

}
