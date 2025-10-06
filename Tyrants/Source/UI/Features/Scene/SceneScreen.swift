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
            viewModel.disconnect(tyrantID: sessionManager.login?.tyrant?.id)
        }
    }
    
    @ViewBuilder
    private func makeBody() -> some View {
        GeometryReader { containerProxy in
            ZStack {
                if case .idle = viewModel.state,
                   viewModel.currentVoting == nil,
                   viewModel.currentBattle == nil {
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
                
                if let model = viewModel.currentVoting,
                   viewModel.currentBattle == nil {
                    if sessionManager.isAdmin() {
                        getVotingAdminView(voting: model.voting)
                    } else {
                        getToPartyView(proxyHeight: containerProxy.size.height)
                        getUntilDeathView(proxyHeight: containerProxy.size.height)
                    }
                }
                
                if let battle = viewModel.currentBattle {
                    ZStack {
                        SceneBattleView(
                            battle: battle,
                            didSelectAttack: { model in
                                viewModel.send(model: model)
                            }
                        )
                        getLastAttackView()
                        getVotingResultView(battle: battle)
                        getBattleResultView()
                    }
                }
                
                if case .error = viewModel.state {
                    makeError()
                    FloatingCloseButtonWrapper()
                }
            }
        }
    }
    
    // MARK: - BATTLE
    
    @ViewBuilder
    private func getBattleResultView() -> some View {
        if let finishedBattleState = viewModel.finishedBattleState {
            LoopingVideoPlayer(
                videoName: finishedBattleState == .win ? "WIN" : "DEFEAT",
                videoType: "mp4"
            )
                .ignoresSafeArea()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        viewModel.resetAllStates()
                        currentVote = nil
                    }
                }
        }
    }
    
    @ViewBuilder
    private func getLastAttackView() -> some View {
        if let lastAttackUsed = viewModel.lastAttackUsed {
            ZStack {
                Color.black.opacity(0.8).ignoresSafeArea()
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.2),
                        Color.black,
                        Color.black.opacity(0.2)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 180)
                .ignoresSafeArea()
                VStack(spacing: 8) {
                    GifImage(name: lastAttackUsed.attack.user)
                        .frame(width: 125, height: 125)
                        .shadow(color: .white, radius: 5)
                    
                    Text("\(lastAttackUsed.attack.user.capitalized) usou \(lastAttackUsed.attack.attack.uppercased()) em \(lastAttackUsed.attack.target.capitalized)")
                        .foregroundStyle(.white)
                        .font(.pressStart(size: 16))
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        viewModel.lastAttackUsed = nil
                    }
                }
            }
        }
    }
    
    // MARK: - VOTING
    
    @ViewBuilder
    private func getVotingResultView(battle: WSBattleStartedModel) -> some View {
        if let _ = viewModel.currentVoting, let voting = battle.voting {
            LoopingVideoPlayer(
                videoName: "\(voting.toParty >= voting.untilDeath ? "TO_PARTY" : "UNTIL_DEATH")_RESULT",
                videoType: "mp4"
            )
            .ignoresSafeArea()
            .transition(
                .asymmetric(
                    insertion: .move(edge: voting.toParty >= voting.untilDeath ? .bottom : .top),
                    removal: .move(edge: voting.toParty >= voting.untilDeath ? .top : .bottom)
                )
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    viewModel.currentVoting = nil
                }
            }
        }
    }
    
    @ViewBuilder
    private func getVotingAdminView(voting: WSVotingModel.Model) -> some View {
        VStack {
            Spacer()
            Text("UNTIL DEATH:")
                .font(.tiny5(size: 32))
                .foregroundStyle(.red)
            Text("\(voting.untilDeath)")
                .font(.tiny5(size: 50))
                .foregroundStyle(.red)
            Spacer()
            Text("TO PARTY:")
                .font(.tiny5(size: 32))
                .foregroundStyle(.cyan)
            Text("\(voting.toParty)")
                .font(.tiny5(size: 50))
                .foregroundStyle(.cyan)
            Spacer()
        }
    }
    
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
            VStack(spacing: 8) {
                makeButton(label: "Clean") {
                    viewModel.send(
                        model: WSCleanModel(
                            clean: true,
                            includeAllies: true,
                            turns: nil
                        )
                    )
                }
                makeButton(label: "Battle") {
                    viewModel.send(
                        model: WSBattleModel(
                            battle: viewModel.currentQueue.first(where: { $0.enemy == true })?.id ?? "",
                            voteEnabled: false
                        )
                    )
                }
                makeButton(label: "Battle with Voting") {
                    viewModel.send(
                        model: WSBattleModel(
                            battle: viewModel.currentQueue.first(where: { $0.enemy == true })?.id ?? "",
                            voteEnabled: true
                        )
                    )
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
                            HighlightableView {
                                viewModel.send(model: WSJoinModel(join: tyrant.id, enemy: true))
                            } content: {
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
