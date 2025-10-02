import SwiftUI

enum FlowNavigationStyle {
    case push(FlowRoute)
    case replace(FlowRoute)
    case present(FlowRoute)
    case pop
}

enum FlowRoute: Hashable, Identifiable {
    case launch
    case home
    case news
    case map
    case bag
    case scene
    
    static var defaultRoute: FlowRoute {
        return .launch
    }
    
    var id: String {
        switch self {
        case .launch: "LAUNCH"
        case .home: "HOME"
        case .news: "NEWS"
        case .map: "MAP"
        case .bag: "BAG"
        case .scene: "SCENE"
        }
    }
}

extension FlowRoute {
    @ViewBuilder
    func makeScreen() -> some View {
        switch self {
        case .launch: LaunchScreen()
        case .home: HomeScreen()
        case .news: NewsScreen()
        case .map: MapScreen()
        case .bag: BagScreen()
        case .scene: SceneScreen()
        }
    }
}
