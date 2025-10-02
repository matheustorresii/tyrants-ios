import Foundation

final class LaunchViewModel: ObservableObject {
    @Published var user: String? = nil
    @Published var state = LaunchScreenState.loading
    
    func fetchUser(_ userId: String) {
        state = .loggedIn(userId)
    }
}
