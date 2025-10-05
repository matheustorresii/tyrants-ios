import Foundation

protocol GetAllTyrantsUseCaseProtocol {
    func execute() async throws -> [TyrantModel]
}

final class GetAllTyrantsUseCase: GetAllTyrantsUseCaseProtocol {
    private let operation: NetworkOperationProtocol
    
    init (operation: NetworkOperationProtocol = NetworkOperation()) {
        self.operation = operation
    }
    
    func execute() async throws -> [TyrantModel] {
        let request = Request.tyrants
        guard let response: [TyrantModel] = try? await operation.request(request) else {
            throw RequestError.unknown
        }
        return response
    }
}
