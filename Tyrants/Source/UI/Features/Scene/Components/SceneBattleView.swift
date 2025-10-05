import SwiftUI

enum ControlsViewState {
    case idle
    case attack
    case target
}

struct SceneBattleView: View {
    @Environment(\.sessionManager) var sessionManager
    @State private var controlsState: ControlsViewState = .idle
    let battle: WSBattleStartedModel
    
    var body: some View {
        ZStack {
            Image("battle-savassi")
                .resizable()
                .ignoresSafeArea()
            makeTurnsView()
            let tyrants = filteredTyrants()
            makeAlliesView(allies: tyrants.allies)
            makeEnemiesView(enemies: tyrants.enemies)
            makeControls()
        }
        .onAppear {
            OrientationManager.set(.landscapeRight)
        }
        .onDisappear {
            OrientationManager.set(.portrait)
        }
    }
    
    @ViewBuilder
    private func makeControls() -> some View {
        switch controlsState {
        case .idle:
            makeIdleControls()
        case .attack:
            Text("Attack")
        case .target:
            Text("Target")
        }
    }
    
    @ViewBuilder
    private func makeIdleControls() -> some View {
        let isMyTurn = battle.turns.first?.id == sessionManager.login?.tyrant?.id
        VStack {
            Spacer()
            HStack {
                Spacer()
                HighlightableView {
                    print("oi")
                } content: {
                    ZStack {
                        Rectangle()
                            .rotation(.degrees(45))
                            .offset(x: 4)
                        Rectangle()
                            .rotation(.degrees(45))
                            .fill((battle.voting?.toParty ?? 0) >= (battle.voting?.untilDeath ?? 0) ? .cyan : .red)
                        Text(isMyTurn ? "ATTACK" : "WAIT FOR YOUR TURN")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                            .font(.tiny5(size: 12))
                            .offset(y: -2)
                    }
                    .opacity(isMyTurn ? 1 : 0.7)
                }
                .frame(
                    width: isMyTurn ? 80 : 60,
                    height: isMyTurn ? 80 : 60
                )
                .allowsHitTesting(isMyTurn)
            }
        }
    }
    
    @ViewBuilder
    private func makeAlliesView(allies: [WSTyrantsModel]) -> some View {
        HStack {
            ZStack {
                ForEach(Array(allies.enumerated()), id: \.offset) { index, tyrant in
                    let offset = getOffsetForTurn(index: index)
                    GifImage(name: tyrant.asset)
                        .frame(width: 120, height: 120)
                        .offset(x: offset.x, y: offset.y)
                        .zIndex(getZIndexForTurn(index: index))
                        .shadow(color: .white, radius: 5)
                }
            }
            .padding(.top, 180)
            .padding(.leading, 70)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func makeEnemiesView(enemies: [WSTyrantsModel]) -> some View {
        HStack {
            Spacer()
            ZStack {
                ForEach(Array(enemies.enumerated()), id: \.offset) {
                    index,
                    tyrant in
                    let offset = getOffsetForTurn(index: index)
                    GifImage(name: tyrant.asset)
                        .frame(width: 150, height: 150)
                        .zIndex(getZIndexForTurn(index: index))
                        .shadow(color: .white, radius: 5)
                        .scaleEffect(x: -1)
                        .overlay {
                            makeHealthBar(
                                currentHp: tyrant.currentHp,
                                fullHp: tyrant.fullHp
                            )
                        }
                        .offset(x: offset.x, y: -offset.y)
                }
            }
            .padding(.top, 150)
            .padding(.trailing, 60)
        }
    }
    
    @ViewBuilder
    private func makeHealthBar(currentHp: Int, fullHp: Int) -> some View {
            ZStack {
                Rectangle()
                    .fill(.black)
                    .offset(x: 4, y: 4)
                    .frame(width: 100, height: 10)
                Rectangle()
                    .fill(.white)
                    .frame(width: 100, height: 10)
                Rectangle()
                    .fill(.black)
                    .padding(1)
                    .frame(width: 100, height: 10)
                HStack {
                    Rectangle()
                        .fill(
                            getColor(
                                currentHp: currentHp,
                                fullHp: fullHp
                            )
                        )
                        .padding(1)
                        .frame(
                            width: (CGFloat(currentHp)/CGFloat(fullHp)) * 100,
                            height: 10
                        )
                    Spacer()
                }
            }
            .frame(width: 100, height: 10)
            .offset(y: -75)
    }
    
    private func getColor(currentHp: Int, fullHp: Int) -> Color {
        if Double(currentHp) > (Double(fullHp) * 0.5) {
            Color.green
        } else if Double(currentHp) > (Double(fullHp) * 0.2) {
            Color.yellow
        } else {
            Color.red
        }
    }
    
    private func getOffsetForTurn(index: Int) -> (x: CGFloat, y: CGFloat) {
        switch index {
        case 0: (x: 120, y: -20)
        case 1: (x: 50, y: 50)
        case 2: (x: -50, y: 0)
        default: (x: 0, y: -50)
        }
    }
    
    private func getZIndexForTurn(index: Int) -> Double {
        switch index {
        case 0: 2
        case 1: 1
        case 2: 2
        default: 4
        }
    }
    
    @ViewBuilder
    private func makeTurnsView() -> some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(battle.turns, id: \.id) { turn in
                    ZStack {
                        Rectangle()
                            .fill(.black)
                            .offset(x: 4, y: 4)
                        Rectangle()
                            .fill(turn.enemy ? .red : .cyan)
                        Rectangle()
                            .fill(.white)
                            .padding(4)
                        GifImage(name: turn.asset)
                            .frame(width: 56, height: 56)
                            .scaleEffect(x: turn.enemy ? -1 : 1)
                    }
                    .frame(width: 60, height: 60)
                }
                .padding(.top, 4)
            }
            Spacer()
        }
    }
    
    func filteredTyrants() -> (allies: [WSTyrantsModel], enemies: [WSTyrantsModel]) {
        var allies = [WSTyrantsModel]()
        var enemies = [WSTyrantsModel]()
        for tyrant in battle.tyrants {
            if tyrant.enemy {
                enemies.append(tyrant)
            } else {
                allies.append(tyrant)
            }
        }
        return (allies: allies, enemies: enemies)
    }
}


#Preview {
    let model = WSBattleStartedModel(
        battle: "platybot",
        turns: [
            .init(id: "mystelune", asset: "mystelune", enemy: false),
            .init(id: "platybot", asset: "platybot", enemy: true),
            .init(id: "fenryl", asset: "fenryl", enemy: false),
            .init(id: "voltaire", asset: "voltaire", enemy: false),
            .init(id: "umbryn", asset: "umbryn", enemy: false),
            .init(id: "gonith", asset: "gonith", enemy: true),
            .init(id: "platybot-b", asset: "platybot", enemy: true),
            .init(id: "gonith-b", asset: "gonith", enemy: true),
        ],
        tyrants: [
            .init(
                id: "mystelune",
                asset: "mystelune",
                fullHp: 10,
                currentHp: 9,
                attacks: [
                    .init(
                        name: "Salto",
                        fullPP: 10,
                        currentPP: 9
                    )
                ]
            ),
            .init(
                id: "platybot",
                asset: "platybot",
                enemy: true,
                fullHp: 10,
                currentHp: 9,
                attacks: [
                    .init(
                        name: "Bicada",
                        fullPP: 10,
                        currentPP: 9
                    )
                ]
            ),
            .init(
                id: "fenryl",
                asset: "fenryl",
                fullHp: 10,
                currentHp: 9,
                attacks: [
                    .init(
                        name: "Arranhão",
                        fullPP: 10,
                        currentPP: 9
                    )
                ]
            ),
            .init(
                id: "voltaire",
                asset: "voltaire",
                fullHp: 10,
                currentHp: 9,
                attacks: [
                    .init(
                        name: "Arranhão",
                        fullPP: 10,
                        currentPP: 9
                    )
                ]
            ),
            .init(
                id: "umbryn",
                asset: "umbryn",
                fullHp: 10,
                currentHp: 9,
                attacks: [
                    .init(
                        name: "Bicada",
                        fullPP: 10,
                        currentPP: 9
                    )
                ]
            ),
            .init(
                id: "gonith",
                asset: "gonith",
                enemy: true,
                fullHp: 10,
                currentHp: 9,
                attacks: [
                    .init(
                        name: "Espadada",
                        fullPP: 10,
                        currentPP: 9
                    )
                ]
            ),
            .init(
                id: "platybot-b",
                asset: "platybot",
                enemy: true,
                fullHp: 10,
                currentHp: 4,
                attacks: [
                    .init(
                        name: "Bicada",
                        fullPP: 10,
                        currentPP: 9
                    )
                ]
            ),
            .init(
                id: "gonith-b",
                asset: "gonith",
                enemy: true,
                fullHp: 10,
                currentHp: 1,
                attacks: [
                    .init(
                        name: "Espadada",
                        fullPP: 10,
                        currentPP: 9
                    )
                ]
            ),
        ],
        voting: .init(toParty: 3, untilDeath: 0)
    )
    SceneBattleView(battle: model)
        .environment(
            \.sessionManager,
             .init(
                login: .init(
                    id: "LITTLE-FLEA",
                    name: "Arthur",
                    tyrant: .init(
                        id: "mystelune",
                        asset: "mystelune",
                        hp: 1,
                        attack: 1,
                        defense: 1,
                        speed: 1
                    ),
                    xp: nil,
                    items: nil,
                    admin: false
                )
             )
        )
}
