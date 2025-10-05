import SwiftUI

enum SceneViewState: Equatable {
    case idle
    case image(imageModel: WSImageModel)
    case battle
    case error
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.image, .image), (.battle, .battle), (.error, .error):
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
    @Published var currentVoting: WSVotingModel?
    @Published var currentBattle: WSBattleStartedModel?
    
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
                Task { @MainActor in
                    self.state = .error
                }
            }
        }
    }
    
    private func parse(_ text: String) {
        print("WS: \(text)")
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            if let decoded = decode(from: WSImageModel.self, with: text) {
                state = .image(imageModel: decoded)
            }
            
            if let decoded = decode(from: WSVotingModel.self, with: text) {
                currentVoting = decoded
            }
            
            if let decoded = decode(from: WSCleanModel.self, with: text) {
                currentQueue = decoded.turns ?? []
            }
            
            if let decoded = decode(from: WSJoinedModel.self, with: text) {
                currentQueue = decoded.turns ?? []
            }
            
            if let decoded = decode(from: WSBattleStartedModel.self, with: text) {
                currentBattle =  decoded
            }
            
            if let decoded = decode(from: WSUpdateStateModel.self, with: text) {
                updateBattle(decoded)
            }
        }
    }
    
    private func updateBattle(_ updateState: WSUpdateStateModel) {
        currentQueue = updateState.turns
        updateState.tyrants.forEach { updatedTyrant in
            let battleTyrantIndex = (currentBattle?.tyrants.firstIndex(where: { $0.id == updatedTyrant.id })!)!
            currentBattle?.tyrants[battleTyrantIndex].currentHp = updatedTyrant.currentHp
            updatedTyrant.attacks.forEach { updatedAttack in
                let battleTyrantAttackIndex = (currentBattle?.tyrants[battleTyrantIndex].attacks.firstIndex(where: { $0.name == updatedAttack.name })!)!
                currentBattle?.tyrants[battleTyrantIndex].attacks[battleTyrantAttackIndex].currentPP = updatedAttack.currentPP
            }
        }
    }
    
    private func decode<T: Decodable>(from: T.Type, with text: String) -> T? {
        return try? JSONDecoder().decode(T.self, from: Data(text.utf8))
    }
}
