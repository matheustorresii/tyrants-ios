import Foundation

protocol NetworkOperationProtocol {
    func request<T: Decodable>(_ request: RequestProtocol) async throws -> T
    func request(_ request: RequestProtocol) async throws -> Bool
}

final class NetworkOperation: NetworkOperationProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    private var baseUrl: String {
        "http://localhost:8080/"
    }
    
    // MARK: - PUBLIC METHODS
    
    func request<T>(_ request: any RequestProtocol) async throws -> T where T : Decodable {
        let urlRequest = try getUrlRequestFor(request: request)
        
        guard let (data, _) = try? await URLSession.shared.data(for: urlRequest) else {
            throw RequestError.connection
        }
        
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            throw RequestError.parsing
        }
        
        return decodedData
    }
    
    func request(_ request: any RequestProtocol) async throws -> Bool {
        let urlRequest = try getUrlRequestFor(request: request)
        
        guard let (_, response) = try? await URLSession.shared.data(for: urlRequest) else {
            throw RequestError.connection
        }
        
        guard let httpUrlResponse = response as? HTTPURLResponse else {
            throw RequestError.unknown
        }
        
        switch httpUrlResponse.statusCode {
        case 200..<300:
            return true
        case 300..<500:
            throw RequestError.client
        default:
            throw RequestError.server
        }
    }
    
    private func getUrlRequestFor(request: RequestProtocol) throws -> URLRequest {
        var endpoint = request.endpoint
        if endpoint.starts(with: "/") {
            endpoint.remove(at: endpoint.startIndex)
        }
        print("trying to make request: \(baseUrl+endpoint)")
        guard let url = URL(string: baseUrl + endpoint) else {
            throw RequestError.client
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        if let requestBody = request.body, let encodedBody = try? JSONEncoder().encode(requestBody) {
            urlRequest.httpBody = encodedBody
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("true", forHTTPHeaderField: "X-Use-Cache")
        return urlRequest
    }
}
