import Combine
import SwiftUI

struct HomeScreen: View {
    
    // MARK: - PUBLIC PROPERTIES
    
    @Environment(\.appCoordinator) var appCoordinator
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            Text("Home")
            Button {
                appCoordinator.navigate(.push(.news))
            } label: {
                Text("Vai pra news")
            }

        }
    }
}
