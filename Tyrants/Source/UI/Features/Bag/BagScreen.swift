import SwiftUI

struct BagScreen: View {
    @Environment(\.sessionManager) var sessionManager
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            if let tyrant = sessionManager.login?.tyrant {
                makeBody(tyrant: tyrant)
            } else {
                Text("Erro, xinga o torres")
                    .font(.tiny5(size: 20))
            }
            FloatingCloseButtonWrapper()
        }
    }
    
    @ViewBuilder
    private func makeBody(tyrant: TyrantModel) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                ZStack {
                    Color.gray.opacity(0.2).ignoresSafeArea()
                    GeometryReader { proxy in
                        GifImage(name: "\(tyrant.asset)-background")
                            .frame(width: proxy.size.width + 10)
                        Rectangle()
                            .fill(.gray)
                            .frame(height: 1)
                            .offset(y: proxy.size.height)
                    }
                    GifImage(name: tyrant.asset)
                        .frame(width: 260, height: 260)
                        .scaleEffect(x: -1)
                        .offset(y: 76)
                        .padding(.top, 50)
                        .shadow(color: .black, radius: 5)
                }
                Spacer().frame(height: 40)
                VStack(alignment: .center, spacing: 0) {
                    Spacer().frame(height: 24)
                    Text(tyrant.id.capitalized)
                        .font(.pressStart(size: 30))
                    Spacer().frame(height: 8)
                    buildStatsViews(tyrant)
                    Spacer().frame(height: 24)
                    HStack {
                        Spacer().frame(width: 24)
                        Text("Items:")
                            .font(.pressStart(size: 22))
                        Spacer()
                    }
                    Spacer().frame(height: 8)
                    LazyVGrid(columns: [
                        .init(.flexible()),
                        .init(.flexible()),
                        .init(.flexible()),
                    ]) {
                        ForEach(0..<9) { _ in
                            Rectangle().aspectRatio(1, contentMode: .fit)
                                .opacity(0.1)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                Spacer().frame(height: 40)
            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func buildStatsViews(_ tyrant: TyrantModel) -> some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("HP")
                    .font(.tiny5(size: 30))

                ZStack {
                    Color.green.opacity(0.6)
                    Text(String(format: "%03d", tyrant.hp))
                        .font(.pressStart(size: 18))
                        .padding(8)
                }
                .frame(width: 70)
            }
            VStack(spacing: 0) {
                Text("ATK")
                    .font(.tiny5(size: 30))

                ZStack {
                    Color.orange.opacity(0.6)
                    Text(String(format: "%03d", tyrant.attack))
                        .font(.pressStart(size: 18))
                        .padding(8)
                }
                .frame(width: 70)
            }
            VStack(spacing: 0) {
                Text("DEF")
                    .font(.tiny5(size: 30))

                ZStack {
                    Color.cyan.opacity(0.5)
                    Text(String(format: "%03d", tyrant.defense))
                        .font(.pressStart(size: 18))
                        .padding(8)
                }
                .frame(width: 70)
            }
            VStack(spacing: 0) {
                Text("SPD")
                    .font(.tiny5(size: 30))

                ZStack {
                    Color.purple.opacity(0.4)
                    Text(String(format: "%03d", tyrant.speed))
                        .font(.pressStart(size: 18))
                        .padding(8)
                }
                .frame(width: 70)
            }
        }
    }
}

#Preview {
    ZStack {
        BagScreen()
    }
    .environment(
        \.sessionManager,
         SessionManager(
            login: .init(
                id: "LITTLE-FLE",
                name: "Pulga owner",
                tyrant: .init(
                    id: "voltaire",
                    asset: "voltaire",
                    evolutions: nil,
                    attacks: [
                        .init(
                            name: "Salto",
                            power: 1,
                            pp: 20,
                            attributes: nil
                        )
                    ],
                    hp: 10,
                    attack: 10,
                    defense: 10,
                    speed: 10
                ),
                xp: 1,
                items: nil
            )
         )
    )
}
