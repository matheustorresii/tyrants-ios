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
    
    let wsService = WebsocketService(urlString: "ws://192.168.18.229:8080/scene/ws")
    
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
        if let decoded = try? JSONDecoder().decode(WSImageModel.self, from: Data(text.utf8)) {
            setState(.image(imageModel: decoded))
        }
    }
    
    private func setState(_ state: SceneViewState) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            withAnimation {
                self.state = state
            }
        }
    }
}
