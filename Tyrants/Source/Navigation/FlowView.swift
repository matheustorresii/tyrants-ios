import SwiftUI

struct FlowView: View {
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $appCoordinator.path) {
            appCoordinator.build(route: .defaultRoute)
                .navigationDestination(for: FlowRoute.self) { route in
                    appCoordinator.build(route: route)
                }
        }
        .environment(\.appCoordinator, appCoordinator)
        .environment(\.colorScheme, .light)
    }
}
