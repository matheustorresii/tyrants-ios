import SwiftUI

struct SceneScreen: View {
    
    @Environment(\.sessionManager) var sessionManager
    @ObservedObject private var viewModel: SceneViewModel = .init()
    
    @State private var currentVote: WSVoteModel.Model?
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).ignoresSafeArea()
            makeBody()
        }
        .onAppear {
            viewModel.connect(tyrantID: sessionManager.login?.tyrant?.id)
        }
        .onDisappear {
            viewModel.disconnect()
        }
    }
    
    @ViewBuilder
    private func makeBody() -> some View {
        GeometryReader { containerProxy in
            ZStack {
                if case .idle = viewModel.state {
                    makeIdle()
                } else {
                    Color.black.ignoresSafeArea()
                }
                Button {
                    withAnimation {
                        viewModel.state = .image(
                            imageModel: .init(
                                image: "news-dex-show",
                                fill: false
                            )
                        )
                    }
                } label: {
                    Text("Test state")
                }
                
                if case .image(let image) = viewModel.state, !sessionManager.isAdmin() {
                    makeImage(imageModel: image, proxy: containerProxy)
                }
                
                if case .voting = viewModel.state, !sessionManager.isAdmin() {
                    getToPartyView(proxyHeight: containerProxy.size.height)
                    getUntilDeathView(proxyHeight: containerProxy.size.height)
                }
                
                if case .error = viewModel.state {
                    makeError()
                    FloatingCloseButtonWrapper()
                }
            }
        }
    }
    
    // MARK: - VOTING
    
    @ViewBuilder
    private func getToPartyView(proxyHeight: CGFloat) -> some View {
        VStack {
            Spacer()
            HighlightableView {
                let vote = WSVoteModel(
                    vote: .toParty,
                    user: sessionManager.login?.tyrant?.id ?? ""
                )
                viewModel.send(model: vote)
                currentVote = .toParty
            } content: {
                LoopingVideoPlayer(videoName: "TO_PARTY", videoType: "mp4")
                    .ignoresSafeArea()
                    .clipShape(ToPartyShape())
                    .frame(height: getToPartyHeight(proxyHeight: proxyHeight))
            }
        }
        .transition(
            .asymmetric(
                insertion: .move(edge: .bottom),
                removal: .move(edge: .bottom)
            )
        )
        .ignoresSafeArea()
        .zIndex(currentVote == .toParty ? 10 : 2)
        .opacity(currentVote != .untilDeath ? 1 : 0.5)
        .allowsHitTesting(currentVote != .toParty)
    }
    
    private func getToPartyHeight(proxyHeight: CGFloat) -> CGFloat {
        proxyHeight/(currentVote == .toParty ? 1.47 : currentVote == .untilDeath ? 2.13 : 1.75)
    }
    
    @ViewBuilder
    private func getUntilDeathView(proxyHeight: CGFloat) -> some View {
        VStack {
            HighlightableView {
                let vote = WSVoteModel(
                    vote: .untilDeath,
                    user: sessionManager.login?.tyrant?.id ?? ""
                )
                viewModel.send(model: vote)
                currentVote = .untilDeath
            } content: {
                LoopingVideoPlayer(videoName: "UNTIL_DEATH", videoType: "mp4")
                    .ignoresSafeArea()
                    .clipShape(UntilDeathShape())
                    .frame(
                        height: getUntilDeathHeight(proxyHeight: proxyHeight)
                    )
            }
            Spacer()
        }
        .transition(
            .asymmetric(
                insertion: .move(edge: .top),
                removal: .move(edge: .top)
            )
        )
        .ignoresSafeArea()
        .zIndex(currentVote == .untilDeath ? 10 : 2)
        .opacity(currentVote != .toParty ? 1 : 0.5)
        .allowsHitTesting(currentVote != .untilDeath)
    }
    
    private func getUntilDeathHeight(proxyHeight: CGFloat) -> CGFloat {
        proxyHeight/(currentVote == .untilDeath ? 1.34 : currentVote == .toParty ? 2 : 1.62)
    }
    
    // MARK: - IMAGE
    
    @ViewBuilder
    private func makeImage(imageModel: WSImageModel, proxy: GeometryProxy) -> some View {
        ZStack {
            SmartImage(source: imageModel.image)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .trailing)
                    )
                )
                .id(imageModel.image)
                .frame(
                    width: imageModel.fill == true ? proxy.size.width : nil,
                    height: imageModel.fill != true ? proxy.size.width : nil
                )
                .clipped()
                .ignoresSafeArea()
            FloatingCloseButtonWrapper()
        }
    }
    
    @ViewBuilder
    private func makeAdminIdle() -> some View {
        
    }
    
    @ViewBuilder
    private func makeIdle() -> some View {
        LoopingVideoPlayer(videoName: "scene-background", videoType: "mp4")
            .ignoresSafeArea()
        Color.black.opacity(0.5).ignoresSafeArea()
        FloatingCloseButtonWrapper()
    }
    
    @ViewBuilder
    private func makeBattle() -> some View {
        
    }
    
    @ViewBuilder
    private func makeError() -> some View {
        Text("Erro, xinga o torres")
            .font(.tiny5(size: 20))
            .foregroundStyle(.white)
    }
}

#Preview {
    SceneScreen()
}
