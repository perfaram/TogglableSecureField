import SwiftUI

extension BindableSecureField {
    internal struct ViewRepresentable: UIViewRepresentable {
        internal var secureContent: Binding<String>
        internal var showContent: Binding<Bool>
        fileprivate var useMonospaced: Bool = false
        fileprivate var onCommit: BindableSecureField.Completion
        
        public init(secureContent: Binding<String>,
                    showContent: Binding<Bool>,
                    onCommit: @escaping BindableSecureField.Completion)
        {
            self.secureContent = secureContent
            self.showContent = showContent
            self.onCommit = onCommit
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(parent: self, onCommit: self.onCommit)
        }

        func makeUIView(context: Context) -> SecureContentPreservingUITextField {
            return context.coordinator.backingTextField
        }

        func updateUIView(_ textField: SecureContentPreservingUITextField, context: Context) {
            context.coordinator.update(content: secureContent.wrappedValue,
                                       showPassword: showContent.wrappedValue,
                                       useMonospaced: useMonospaced)
        }
        
        func useMonospacedFont(_ useMonospaced: Bool) -> Self {
            var this = self
            this.useMonospaced = useMonospaced
            return this
        }
    }
}
