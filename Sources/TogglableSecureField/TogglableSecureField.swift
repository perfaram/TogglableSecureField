import SwiftUI

public struct TogglableSecureField<LeftViewT>: View where LeftViewT: View {
    
    private var placeholderView: Text
    private var leftViewClosure: (() -> LeftViewT)? = nil
    public var password: Binding<String>
    public let onCommit: BindableSecureField.Completion
    private var _useMonospacedFont: Bool = false
    
    @State public var showPassword: Bool = false
    
    public func useMonospacedFont(_ useMonospaced: Bool = true) -> Self {
        var this = self
        this._useMonospacedFont = useMonospaced
        return this
    }
    
    let textFieldHeight: CGFloat = 50
    
    public var body: some View {
        HStack {
            leftViewClosure?()
            
            ZStack(alignment: .leading) {
                if password.wrappedValue.isEmpty {
                    placeholderView
                        .monospaced(_useMonospacedFont)
                        .placeholderStyled
                }
                secureTextField
            }
            
            if !password.wrappedValue.isEmpty {
                Button(action: {
                    self.showPassword.toggle()
                }, label: {
                    ZStack(alignment: .trailing){
                        // Eye(.slash) also provide a default, localized accessibility identifier for this button.
                        // Eye = Show; Eye.Slash = Hide
                        // This seems to be a SwiftUI feature.
                        Image(systemName: self.showPassword ? "eye.slash.fill" : "eye.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.init(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0))
                    }
                })
            }
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder var secureTextField: some View {
        BindableSecureField.ViewRepresentable(secureContent: password,
                                              showContent: $showPassword,
                                              onCommit: onCommit)
            .useMonospacedFont(_useMonospacedFont)
            .accessibilityLabel(placeholderView)
    }
}

extension TogglableSecureField where LeftViewT == Never {
    public init(_ localizedLabel: LocalizedStringKey,
                secureContent contentBinding: Binding<String>,
                onCommit: @escaping BindableSecureField.Completion)
    {
        self.placeholderView = Text(localizedLabel)
        self.password = contentBinding
        self.onCommit = onCommit
    }
    
    @_disfavoredOverload
    public init<S>(_ title: S,
                   secureContent contentBinding: Binding<String>,
                   onCommit: @escaping BindableSecureField.Completion)
    where S : StringProtocol
    {
        self.placeholderView = Text(title)
        self.password = contentBinding
        self.onCommit = onCommit
    }
}

extension TogglableSecureField where LeftViewT: View {
    public init(_ localizedLabel: LocalizedStringKey,
                secureContent contentBinding: Binding<String>,
                @ViewBuilder leftView: @escaping () -> LeftViewT,
                onCommit: @escaping BindableSecureField.Completion)
    {
        self.placeholderView = Text(localizedLabel)
        self.leftViewClosure = leftView
        self.password = contentBinding
        self.onCommit = onCommit
    }
    
    @_disfavoredOverload
    public init<S>(_ title: S,
                   secureContent contentBinding: Binding<String>,
                   @ViewBuilder leftView: @escaping () -> LeftViewT,
                   onCommit: @escaping BindableSecureField.Completion)
    where S : StringProtocol
    {
        self.placeholderView = Text(title)
        self.leftViewClosure = leftView
        self.password = contentBinding
        self.onCommit = onCommit
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
            TogglableSecureField("DemoField", secureContent: binding, onCommit: {
                print(wrapper.value)
            })
                .useMonospacedFont()
        }
        .padding()
    }
}
