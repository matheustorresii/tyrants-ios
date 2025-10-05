import SwiftUI

struct HomeScreen: View {
    
    // MARK: - PUBLIC PROPERTIES
    
    @Environment(\.appCoordinator) var appCoordinator
    @Environment(\.sessionManager) var sessionManager
    
    // MARK: - BODY
    
    var body: some View {
        makeButtonContainers()
    }
    
    // MARK: - VIEWS
    
    @ViewBuilder
    private func makeButtonContainers() -> some View {
        let buttons = createButtonValues()
        VStack(spacing: 0) {
            ForEach(0..<buttons.count, id: \.self) { index in
                if index.isMultiple(of: 2) {
                    if index + 1 < buttons.count {
                        HStack(spacing: 0) {
                            let firstButton = buttons[index]
                            makeButton(route: firstButton.route, dto: firstButton.dto)
                            let secondButton = buttons[index+1]
                            makeButton(route: secondButton.route, dto: secondButton.dto)
                        }
                    } else {
                        HStack {
                            let button = buttons[index]
                            makeButton(route: button.route, dto: button.dto)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func makeButton(route: FlowRoute, dto: HomeButtonDTO) -> some View {
        HighlightableView {
            appCoordinator.navigate(.push(route))
        } content: {
            HomeButton(dto: dto)
        }
    }
    
    private func createButtonValues() -> [(
        route: FlowRoute,
        dto: HomeButtonDTO
    )] {
        var result: [(route: FlowRoute, dto: HomeButtonDTO)] = [
            (
                route: .news,
                dto: .init(
                    image: "news-icon",
                    title: "NEWS",
                    color: .orange,
                    textColor: .white
                )
            )
        ]
        if false {
            result.append(
                (
                    route: .map,
                    dto: .init(
                        image: "map-icon",
                        title: "MAP",
                        color: .green,
                        textColor: .white
                    )
                )
            )
        }
        if let _ = sessionManager.login?.tyrant {
            result.append((
                route: .bag,
                dto: .init(
                    image: "spirit-icon",
                    title: "SPIRIT",
                    color: .cyan,
                    textColor: .white
                )
            ))
        }
        result.append(
            (
                route: .scene,
                dto: .init(
                    image: "scene-icon",
                    title: "SCENE",
                    color: .red,
                    textColor: .white
                )
            )
        )
        return result
    }
}

#Preview {
    HomeScreen()
}
