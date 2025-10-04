import Foundation

enum NewsScreenState {
    case loading
    case content([NewsModel])
    case error
}

final class NewsViewModel: ObservableObject {
    @Published var state = NewsScreenState.loading
    
    private let useCase: NewsUseCaseProtocol = NewsUseCase()
    
    func fetchNews() {
        state = .loading
        Task { @MainActor in
            guard let response = try? await self.useCase.execute() else {
                state = .error
                return
            }
            state = .content(response)
        }
    }
}
