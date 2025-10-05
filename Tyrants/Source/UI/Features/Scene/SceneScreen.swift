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
                    if sessionManager.isAdmin() {
                        Color.black.opacity(0.7).ignoresSafeArea()
                        makeAdminIdle()
                    }
                    FloatingCloseButtonWrapper()
                } else {
                    Color.black.ignoresSafeArea()
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
                    vote: .TO_PARTY,
                    user: sessionManager.login?.tyrant?.id ?? ""
                )
                viewModel.send(model: vote)
                currentVote = .TO_PARTY
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
        .zIndex(currentVote == .TO_PARTY ? 10 : 2)
        .opacity(currentVote != .UNTIL_DEATH ? 1 : 0.5)
        .allowsHitTesting(currentVote != .TO_PARTY)
    }
    
    private func getToPartyHeight(proxyHeight: CGFloat) -> CGFloat {
        proxyHeight/(currentVote == .TO_PARTY ? 1.47 : currentVote == .UNTIL_DEATH ? 2.13 : 1.75)
    }
    
    @ViewBuilder
    private func getUntilDeathView(proxyHeight: CGFloat) -> some View {
        VStack {
            HighlightableView {
                let vote = WSVoteModel(
                    vote: .UNTIL_DEATH,
                    user: sessionManager.login?.tyrant?.id ?? ""
                )
                viewModel.send(model: vote)
                currentVote = .UNTIL_DEATH
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
        .zIndex(currentVote == .UNTIL_DEATH ? 10 : 2)
        .opacity(currentVote != .TO_PARTY ? 1 : 0.5)
        .allowsHitTesting(currentVote != .UNTIL_DEATH)
    }
    
    private func getUntilDeathHeight(proxyHeight: CGFloat) -> CGFloat {
        proxyHeight/(currentVote == .UNTIL_DEATH ? 1.34 : currentVote == .TO_PARTY ? 2 : 1.62)
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
        ScrollView {
            VStack {
                makeButton(label: "Clean") {
                    viewModel.send(model: WSCleanModel(clean: true, turns: nil))
                }
                Text("Queue:")
                    .font(.tiny5(size: 32))
                    .foregroundStyle(.white)
                LazyVGrid(columns: [
                    .init(.flexible()),
                    .init(.flexible()),
                    .init(.flexible())
                ]) {
                    ForEach(viewModel.currentQueue, id: \.id) { tyrant in
                        ZStack {
                            Rectangle()
                                .fill(tyrant.enemy == true ? .red : .cyan)
                                .aspectRatio(0.8, contentMode: .fit)
                                .offset(x: 4, y: 4)
                            Rectangle()
                                .fill(tyrant.enemy == true ? .red : .cyan)
                                .aspectRatio(0.8, contentMode: .fit)
                            VStack {
                                GifImage(name: tyrant.asset)
                                    .background { Rectangle().fill(.white) }
                                Text(tyrant.id.uppercased())
                                    .font(.tiny5(size: 16))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }
                Text("Spirits:")
                    .font(.tiny5(size: 32))
                    .foregroundStyle(.white)
                if viewModel.tyrants.isEmpty {
                    Text("Loading")
                        .font(.tiny5(size: 32))
                        .foregroundStyle(.white)
                } else {
                    LazyVGrid(columns: [
                        .init(.flexible()),
                        .init(.flexible()),
                        .init(.flexible())
                    ]) {
                        ForEach(viewModel.tyrants, id: \.id) { tyrant in
                            ZStack {
                                Rectangle()
                                    .fill(.black)
                                    .aspectRatio(0.8, contentMode: .fit)
                                    .offset(x: 4, y: 4)
                                Rectangle()
                                    .fill(.white)
                                    .aspectRatio(0.8, contentMode: .fit)
                                VStack {
                                    GifImage(name: tyrant.asset)
                                    Text(tyrant.id.uppercased())
                                        .font(.tiny5(size: 16))
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, 100)
            .padding(.horizontal, 24)
        }
        .onAppear {
            viewModel.fetchTyrants()
        }
    }
    
    @ViewBuilder
    private func makeButton(label: String, action: (() -> Void)?) -> some View {
        HighlightableView {
            action?()
        } content: {
            ZStack {
                Rectangle().fill(.black)
                    .frame(height: 44)
                    .offset(x: 4, y: 4)
                Rectangle().fill(.white)
                    .frame(height: 44)
                Text(label)
                    .font(.tiny5(size: 22))
            }
        }
    }
    
    @ViewBuilder
    private func makeIdle() -> some View {
        LoopingVideoPlayer(videoName: "scene-background", videoType: "mp4")
            .ignoresSafeArea()
        Color.black.opacity(0.5).ignoresSafeArea()
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
        .environment(
            \.sessionManager,
             .init(
                login: .init(
                    id: "KIWI-TURRET",
                    name: "Torres",
                    tyrant: nil,
                    xp: nil,
                    items: nil,
                    admin: true
                )
             )
        )
}
