import Foundation

protocol LoginUseCaseProtocol {
    func execute(request: LoginRequest) async throws -> LoginResponse
}

final class LoginUseCase: LoginUseCaseProtocol {
    private let operation: NetworkOperationProtocol
    
    init (operation: NetworkOperationProtocol = NetworkOperation()) {
        self.operation = operation
    }
    
    func execute(request: LoginRequest) async throws -> LoginResponse {
        let request = Request.login(req: request)
        guard let response: LoginResponse = try? await operation.request(request) else {
            throw RequestError.unknown
        }
        return response
    }
}
