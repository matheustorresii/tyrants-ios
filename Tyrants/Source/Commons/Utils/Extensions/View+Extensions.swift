import SwiftUI

extension View {
    func toAny() -> AnyView {
        return .init(self)
    }
    
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
