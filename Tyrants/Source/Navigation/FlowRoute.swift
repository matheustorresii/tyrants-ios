import Foundation

enum FlowNavigationStyle {
    case push(FlowRoute)
    case replace(FlowRoute)
    case present(FlowRoute)
    case pop
}

enum FlowRoute: Hashable, Identifiable {
    case home
    case news
    case map
    case bag
    case scene
    
    static var defaultRoute: FlowRoute {
        return .home
    }
    
    var id: String {
        switch self {
        case .home: "HOME"
        case .news: "NEWS"
        case .map: "MAP"
        case .bag: "BAG"
        case .scene: "SCENE"
        }
    }
}
