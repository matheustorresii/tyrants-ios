import Foundation

enum SceneViewState {
    case idle
    case image
    case battle
    case voting
}

final class SceneViewModel: ObservableObject {
    @Published var state = SceneViewState.idle
    
    let wsService = WebsocketService(urlString: "ws://192.168.18.229:8080/scene/ws")
    
    func connect() {
        wsService.connect()
    }
    
    func disconnect() {
        wsService.disconnect()
    }
}
