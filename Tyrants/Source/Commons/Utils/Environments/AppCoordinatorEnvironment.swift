import SwiftUI

private struct AppCoordinatorEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppCoordinatorProtocol = AppCoordinator()
}

extension EnvironmentValues {
    var appCoordinator: AppCoordinatorProtocol {
        get {
            self[AppCoordinatorEnvironmentKey.self]
        } set {
            self[AppCoordinatorEnvironmentKey.self] = newValue
        }
    }
}
