import Foundation

protocol NewsUseCaseProtocol {
    func execute() async throws -> [NewsModel]
}

final class NewsUseCase: NewsUseCaseProtocol {
    private let operation: NetworkOperationProtocol
    
    init (operation: NetworkOperationProtocol = NetworkOperation()) {
        self.operation = operation
    }
    
    func execute() async throws -> [NewsModel] {
        let request = Request.news
        guard let response: [NewsModel] = try? await operation.request(request) else {
            throw RequestError.unknown
        }
        return response
    }
}
