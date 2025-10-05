import Foundation

protocol WebsocketServiceProtocol {
    func connect()
    func disconnect()
    func send<T: Encodable>(_ message: T) async throws
    func listen(handler: @escaping (Result<String, any Error>) -> Void)
}

final class WebsocketService: WebsocketServiceProtocol {
    private var task: URLSessionWebSocketTask?
    private let urlString: String
    private let session: URLSession
    
    init(urlString: String) {
        self.urlString = urlString
        self.session = .init(configuration: .default)
    }
    
    func connect() {
        guard let url = URL(string: urlString) else {
            print("URL inválida \(urlString)")
            return
        }
        task = session.webSocketTask(with: url)
        task?.resume()
        print("WebSocket conectado")
    }
    
    func disconnect() {
        task?.cancel(with: .goingAway, reason: nil)
        print("WebSocket desconectado")
    }
    
    func send<T>(_ message: T) async throws where T : Encodable {
        let data = try JSONEncoder().encode(message)
        let jsonString = String(data: data, encoding: .utf8) ?? "ERRO: Não foi possível converter para JSON"
        try await task?.send(.string(jsonString))
    }
    
    func listen(handler: @escaping (Result<String, any Error>) -> Void) {
        task?.receive { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let message):
                switch message {
                case .string(let text):
                    handler(.success(text))
                default:
                    break
                }
            }
            listen(handler: handler)
        }
    }
}
