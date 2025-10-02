import SwiftUI

private struct AppCoordinatorEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppCoordinatorProtocol = AppCoordinator()
}

private struct DataPersistenceEnvironmentKey: EnvironmentKey {
    static let defaultValue = DataPersistenceManager()
}

extension EnvironmentValues {
    var appCoordinator: AppCoordinatorProtocol {
        get {
            self[AppCoordinatorEnvironmentKey.self]
        } set {
            self[AppCoordinatorEnvironmentKey.self] = newValue
        }
    }
    
    var dataPersistence: DataPersistenceManager {
        get {
            self[DataPersistenceEnvironmentKey.self]
        } set {
            self[DataPersistenceEnvironmentKey.self] = newValue
        }
    }
}
