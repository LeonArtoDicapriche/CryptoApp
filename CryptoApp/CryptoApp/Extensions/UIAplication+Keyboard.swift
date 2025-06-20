import SwiftUI

extension UIApplication {
    /// Call when is needed to hide keyboard
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
