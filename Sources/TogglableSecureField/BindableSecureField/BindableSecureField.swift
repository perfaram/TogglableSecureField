import SwiftUI

public struct BindableSecureField: View {
    
    public var secureContent: Binding<String>
    public var showContent: Binding<Bool>
    
    public typealias Completion = () -> Void
    public let onCommit: Self.Completion
    
    internal let label: String
    internal var _useMonospacedFont: Bool = true
    
    init(_ label: String,
         secureContent: Binding<String>,
         showContent: Binding<Bool>,
         onCommit: @escaping Completion)
    {
        self.label = label
        self.secureContent = secureContent
        self.showContent = showContent
        self.onCommit = onCommit
    }
    
    public var body: some View {
        BindableSecureField.ViewRepresentable(
            secureContent: secureContent,
            showContent: showContent,
            label: label,
            onCommit: onCommit)
            .useMonospacedFont(_useMonospacedFont)
    }
}
