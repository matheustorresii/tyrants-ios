import Combine
import SwiftUI

protocol AppCoordinatorProtocol {
    func navigate(_ style: FlowNavigationStyle)
}

final class AppCoordinator: ObservableObject, AppCoordinatorProtocol {
    
    // MARK: - PUBLIC PROPERTIES
    
    @Published
    var path: NavigationPath
    
    // MARK: - PRIVATE PROPERTIES
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - INITIALIZERS
    
    init(path: NavigationPath = .init()) {
        self.path = path
    }
    
    // MARK: - PUBLIC METHODS
    
    @ViewBuilder
    func build(route: FlowRoute) -> some View {
        viewFor(route: route).toAny()
    }
    
    func navigate(_ style: FlowNavigationStyle) {
        switch style {
        case .push(let route):
            path.append(route)
        case .pop:
            path.removeLast()
        }
    }
    
    // MARK: - PRIVATE METHODS
    
    private func viewFor(route: FlowRoute) -> any View {
        switch route {
        case .home:
            HomeScreen()
        case .news:
            NewsScreen()
        }
    }
}
