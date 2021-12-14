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
    
    var gestureDelegate: TrampolineDelegate? = nil
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) {
            gestureRecognizer.cancelsTouchesInView = false
            if !(gestureRecognizer.delegate?.isKind(of: TrampolineDelegate.self) ?? false) {
                gestureDelegate = TrampolineDelegate(gestureRecognizer.delegate)
                gestureRecognizer.delegate = gestureDelegate
            }
        }
        
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    
}

@objc class TrampolineDelegate: NSObject, UIGestureRecognizerDelegate {
    override func responds(to aSelector: Selector!) -> Bool {
        return target?.responds(to: aSelector) ?? false
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return target
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) {
            return false
        }
        if otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            return false
        }
        return target?.gestureRecognizer?(gestureRecognizer, shouldRecognizeSimultaneouslyWith: otherGestureRecognizer) ?? false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) {
            return true
        }
        if otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            return true
        }
        
        return target?.gestureRecognizer?(gestureRecognizer, shouldRecognizeSimultaneouslyWith: otherGestureRecognizer) ?? true
    }
    
    weak var target: UIGestureRecognizerDelegate?
    init(_ targetObject: UIGestureRecognizerDelegate?) {
        target = targetObject
    }
}
