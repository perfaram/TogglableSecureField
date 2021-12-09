import SwiftUI

class SecureContentPreservingUITextField: UITextField {
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

struct BoundSecurityTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var showPassword: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIViewFont(_ textField: SecureContentPreservingUITextField, context: Context) {
        let font: UIFont
        if textField.isSecureTextEntry {
            font = UIFont.monospacedSystemFont(ofSize: textField.font!.pointSize,
                                               weight: UIFont.Weight.regular)
        }
        else {
            font = UIFont.monospacedSystemFont(ofSize: textField.font!.pointSize,
                                               weight: UIFont.Weight.regular)
        }
        textField.font = font
    }

    let textField = SecureContentPreservingUITextField()
    func makeUIView(context: Context) -> SecureContentPreservingUITextField {
        textField.delegate = context.coordinator
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.text = text
        textField.textContentType = .password
        textField.isSecureTextEntry = !showPassword
        updateUIViewFont(textField, context: context)
        return textField
    }

    func updateUIView(_ textField: SecureContentPreservingUITextField, context: Context) {
        if !showPassword != textField.isSecureTextEntry {
            textField.isSecureTextEntry = !showPassword
            updateUIViewFont(textField, context: context)
        }
        
        if text != context.coordinator.currentText {
            textField.text = text
        }
    }
    
    func onCommit(_ closure: @escaping () -> Void) -> Self {
        textField.addAction(UIAction(handler: { _ in
            closure()
        }), for: UIControl.Event.primaryActionTriggered)
        return self
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: BoundSecurityTextField
        var currentText: String
        
        init(_ parent: BoundSecurityTextField) {
            currentText = parent.$text.wrappedValue
            self.parent = parent
        }
        
        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool
        {
            guard let oldText = textField.text, let textRange = Range(range, in: oldText) else {
                return false
            }

            currentText = oldText.replacingCharacters(in: textRange, with: string)
            parent.$text.wrappedValue = currentText

            return true
        }
    }
}

public struct TogglableSecureField: View {
    @Binding public var password: String
    public let completionAction: () -> Void
    
    @State public var showPassword: Bool = false
    
    @ViewBuilder func secureTextField() -> some View {
        BoundSecurityTextField(text: $password, showPassword: $showPassword)
            .onCommit {
                guard !password.isEmpty else { return }
                completionAction()
            }
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 60, alignment: .center)
    }
    
    public var body: some View {
        HStack{
            Image(systemName: "lock.fill")
                .foregroundColor(password.isEmpty ? .secondary : .primary)
                .font(.system(size: 18, weight: .medium, design: .default))
                .frame(width: 18, height: 18, alignment: .center)
            secureTextField()
            if !password.isEmpty {
                Button(action: {
                    self.showPassword.toggle()
                }, label: {
                    ZStack(alignment: .trailing){
                        Color.clear
                            .frame(maxWidth: 29, maxHeight: 60, alignment: .center)
                        Image(systemName: self.showPassword ? "eye.slash.fill" : "eye.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.init(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0))
                    }
                })
            }
        }
        .padding(.horizontal, 15)
        .background(Color.primary.opacity(0.05).cornerRadius(10))
        .padding(0)
    }
}



public struct TogglableSecureField_Previews: PreviewProvider {
    private struct StatefulPreviewWrapper<Value, Content: View>: View {
        @State var value: Value
        var content: (Self, Binding<Value>) -> Content

        var body: some View {
            content(self, $value)
        }

        init(_ value: Value, content: @escaping (Self, Binding<Value>) -> Content) {
            self._value = State(wrappedValue: value)
            self.content = content
        }
    }
    
    public static var previews: some View {
        StatefulPreviewWrapper("") { wrapper, binding in
            TogglableSecureField(password: binding, completionAction: {
                print(wrapper.value)
            })
        }
        .padding()
    }
}
