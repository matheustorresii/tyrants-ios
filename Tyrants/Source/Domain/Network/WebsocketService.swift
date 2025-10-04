import Foundation

protocol WebsocketServiceProtocol {
    func connect()
    func disconnect()
    func send<T: Encodable>(_ message: T) async throws
    func listen<T: Decodable>(as type: T.Type, handler: @escaping (Result<T, Error>) -> Void)
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
        listenContinuously()
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
    
    func listen<T>(as type: T.Type, handler: @escaping (Result<T, any Error>) -> Void) where T : Decodable {
        task?.receive { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let message):
                switch message {
                case .string(let text):
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: Data(text.utf8))
                        handler(.success(decoded))
                    } catch {
                        handler(.failure(error))
                    }
                default:
                    break
                }
            }
            self.listen(as: T.self, handler: handler)
        }
    }
    
    private func listenContinuously() {
        task?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Recebido: \(text)")
                default:
                    break
                }
            case .failure(let error):
                print("Erro websocket: \(error)")
            }
            self?.listenContinuously()
        }
    }
}
