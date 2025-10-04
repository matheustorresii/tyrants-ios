import SwiftUI

struct SceneScreen: View {
    
    @ObservedObject private var viewModel: SceneViewModel = .init()
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).ignoresSafeArea()
            makeBody()
            FloatingCloseButtonWrapper()
        }
        .onAppear {
            viewModel.connect()
        }
        .onDisappear {
            viewModel.disconnect()
        }
    }
    
    @ViewBuilder
    private func makeBody() -> some View {
        switch viewModel.state {
        case .idle:
            makeIdle()
        case .battle:
            makeBattle()
        case .image:
            makeImage()
        case .voting:
            makeVoting()
        }
    }
    
    @ViewBuilder
    private func makeIdle() -> some View {
        ZStack {
            LoopingVideoPlayer(videoName: "scene-background", videoType: "mp4")
                .ignoresSafeArea()
            Color.black.opacity(0.5).ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private func makeImage() -> some View {
        
    }
    
    @ViewBuilder
    private func makeBattle() -> some View {
        
    }
    
    @ViewBuilder
    private func makeVoting() -> some View {
        
    }
}

#Preview {
    SceneScreen()
}
