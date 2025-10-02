import Combine
import SwiftUI

protocol AppCoordinatorProtocol {
    func navigate(_ style: FlowNavigationStyle)
}

final class AppCoordinator: ObservableObject, AppCoordinatorProtocol {
    
    // MARK: - PUBLIC PROPERTIES
    
    @Published
    var path: NavigationPath
    @Published
    var rootRoute: FlowRoute = .defaultRoute
    @Published
    var presentedRoute: FlowRoute?
    
    // MARK: - PRIVATE PROPERTIES
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - INITIALIZERS
    
    init(path: NavigationPath = .init()) {
        self.path = path
    }
    
    // MARK: - PUBLIC METHODS
    
    @ViewBuilder
    func build(route: FlowRoute) -> some View {
        route.makeScreen().toAny()
    }
    
    func navigate(_ style: FlowNavigationStyle) {
        switch style {
        case .push(let route):
            path.append(route)
        case .replace(let route):
            path = NavigationPath()
            rootRoute = route
        case .present(let route):
            presentedRoute = route
        case .pop:
            if !path.isEmpty {
                path.removeLast()
            }
        }
    }
}
