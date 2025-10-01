import Foundation

enum FlowNavigationStyle {
    case push(FlowRoute)
    case pop
}

enum FlowRoute {
    case home
    case news
    
    static var defaultRoute: FlowRoute {
        return .home
    }
}

extension FlowRoute: Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.home, .home), (.news, .news):
            return true
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .home:
            hasher.combine(1)
        case .news:
            hasher.combine(2)
        }
    }
}
