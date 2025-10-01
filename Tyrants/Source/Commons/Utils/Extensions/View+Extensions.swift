import SwiftUI

extension View {
    func toAny() -> AnyView {
        return .init(self)
    }
}
