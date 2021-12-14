import SwiftUI

extension BindableSecureField {
    public func useMonospacedFont(_ useMonospaced: Bool = true) -> Self {
        var this = self
        this._useMonospacedFont = useMonospaced
        return this
    }
}
