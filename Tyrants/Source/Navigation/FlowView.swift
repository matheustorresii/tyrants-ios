import SwiftUI

struct FlowView: View {
    @StateObject private var appCoordinator = AppCoordinator()
    private let dataPersistenceManager = DataPersistenceManager()
    private let sessionManager = SessionManager()
    
    var body: some View {
        NavigationStack(path: $appCoordinator.path) {
            appCoordinator.build(route: appCoordinator.rootRoute)
                .navigationDestination(for: FlowRoute.self) { route in
                    appCoordinator.build(route: route)
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                }
        }
        .fullScreenCover(item: $appCoordinator.presentedRoute) { route in
            appCoordinator.build(route: route)
        }
        .environment(\.appCoordinator, appCoordinator)
        .environment(\.dataPersistence, dataPersistenceManager)
        .environment(\.sessionManager, sessionManager)
        .environment(\.colorScheme, .light)
    }
}
