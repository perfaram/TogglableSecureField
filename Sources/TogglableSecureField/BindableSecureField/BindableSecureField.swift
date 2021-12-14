import SwiftUI

public struct BindableSecureField: View {
    
    public var secureContent: Binding<String>
    public var showContent: Binding<Bool>
    
    public typealias Completion = () -> Void
    public let onCommit: Self.Completion
    
    internal let placeholderView: Text
    internal var _useMonospacedFont: Bool = true
    
    public var body: some View {
        ZStack(alignment: .leading) {
            if secureContent.wrappedValue.isEmpty {
                placeholderView
                    .foregroundColor(Color(UIColor.placeholderText))
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }
            BindableSecureField.ViewRepresentable(
                secureContent: secureContent,
                showContent: showContent,
                onCommit: onCommit)
                .useMonospacedFont(_useMonospacedFont)
                .accessibilityLabel(placeholderView)
        }
    }
}

extension BindableSecureField {
    public init(_ localizedLabel: LocalizedStringKey,
                secureContent contentBinding: Binding<String>,
                showContent: Binding<Bool>,
                onCommit: @escaping BindableSecureField.Completion)
    {
        self.placeholderView = Text(localizedLabel)
        self.secureContent = contentBinding
        self.showContent = showContent
        self.onCommit = onCommit
    }
    
    @_disfavoredOverload
    public init<S>(_ title: S,
                   secureContent contentBinding: Binding<String>,
                   showContent: Binding<Bool>,
                   onCommit: @escaping BindableSecureField.Completion)
    where S : StringProtocol
    {
        self.placeholderView = Text(title)
        self.secureContent = contentBinding
        self.showContent = showContent
        self.onCommit = onCommit
    }
}
