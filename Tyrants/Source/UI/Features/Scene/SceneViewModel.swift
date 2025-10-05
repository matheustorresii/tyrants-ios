import SwiftUI

enum SceneViewState: Equatable {
    case idle
    case image(imageModel: WSImageModel)
    case battle
    case voting
    case error
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.image, .image), (.battle, .battle), (.voting, .voting), (.error, .error):
            true
        default:
            false
        }
    }
}

@MainActor
final class SceneViewModel: ObservableObject {
    @Published var state = SceneViewState.idle
    @Published var tyrants = [TyrantModel]()
    @Published var currentQueue: [WSTurnsModel] = []
    
    let wsService = WebsocketService(urlString: "ws://192.168.18.229:8080/scene/ws")
    
    private let useCase: GetAllTyrantsUseCaseProtocol = GetAllTyrantsUseCase()
    
    func connect(tyrantID: String?) {
        wsService.connect()
        listen()
        if let tyrantID {
            send(model: WSJoinModel(join: tyrantID, enemy: false))
        }
    }
    
    func disconnect() {
        wsService.disconnect()
    }
    
    func send(model: Encodable) {
        Task {
            do {
                try await wsService.send(model)
            } catch {
                print("Erro \(error)")
            }
        }
    }
    
    func fetchTyrants() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            guard let response = try? await self.useCase.execute() else {
                state = .error
                return
            }
            tyrants = response
        }
    }
    
    private func listen() {
        wsService.listen { [weak self] text in
            guard let self else { return }
            switch text {
            case .success(let text):
                parse(text)
            case .failure:
                setState(.error)
            }
        }
    }
    
    private func parse(_ text: String) {
        print("WS: \(text)")
        if let decoded = decode(from: WSImageModel.self, with: text) {
            setState(.image(imageModel: decoded))
        }
        
        if let decoded = decode(from: WSVotingModel.self, with: text) {
            setState(.voting)
        }
        
        if let decoded = decode(from: WSCleanModel.self, with: text) {
            setQueue(queue: decoded.turns ?? [])
        }
        
        if let decoded = decode(from: WSJoinedModel.self, with: text) {
            setQueue(queue: decoded.turns ?? [])
        }
    }
    
    private func decode<T: Decodable>(from: T.Type, with text: String) -> T? {
        return try? JSONDecoder().decode(T.self, from: Data(text.utf8))
    }
    
    private func setState(_ state: SceneViewState) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            withAnimation {
                self.state = state
            }
        }
    }
    
    private func setQueue(queue: [WSTurnsModel]) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            withAnimation {
                self.currentQueue = queue
            }
        }
    }
}
