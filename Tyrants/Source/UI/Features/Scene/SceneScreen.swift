import SwiftUI

struct SceneScreen: View {
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).ignoresSafeArea()
            LoopingVideoPlayer(videoName: "scene-background", videoType: "mp4")
                .ignoresSafeArea()
            Color.black.opacity(0.5).ignoresSafeArea()
            FloatingCloseButtonWrapper()
        }
    }
}

#Preview {
    SceneScreen()
}
