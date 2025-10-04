import Foundation

enum LaunchScreenState {
    case loading
    case loggedIn(LoginResponse)
    case loggedOut
    case error
}

final class LaunchViewModel: ObservableObject {
    @Published var user: String? = nil
    @Published var state = LaunchScreenState.loading
    
    private let useCase: LoginUseCaseProtocol = LoginUseCase()
    
    func fetchUser(_ userId: String) {
        state = .loading
        Task { @MainActor in
            guard let response = try? await self.useCase.execute(request: .init(id: userId)) else {
                state = .error
                return
            }
            state = .loggedIn(response)
        }
    }
}
