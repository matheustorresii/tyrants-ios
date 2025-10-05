import SwiftUI

struct ToPartyShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY/8))
        path.closeSubpath()
        return path
    }
}

struct UntilDeathShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - rect.maxY/8))
        path.closeSubpath()
        return path
    }
}

#Preview {
    GeometryReader { containerProxy in
        ZStack {
            VStack {
                Spacer()
                HighlightableView {
                    print("TO_PARTY")
                } content: {
                    LoopingVideoPlayer(videoName: "TO_PARTY", videoType: "mp4")
                        .ignoresSafeArea()
                        .clipShape(ToPartyShape())
                        .frame(height: containerProxy.size.height/2)
                }

            }
            .transition(
                .asymmetric(
                    insertion: .move(edge: .top),
                    removal: .move(edge: .top)
                )
            )
            VStack {
                HighlightableView {
                    print("UNTIL_DEATH")
                } content: {
                    LoopingVideoPlayer(videoName: "UNTIL_DEATH", videoType: "mp4")
                        .ignoresSafeArea()
                        .clipShape(UntilDeathShape())
                        .frame(height: containerProxy.size.height/1.75)
                }
                Spacer()
            }
            .transition(
                .asymmetric(
                    insertion: .move(edge: .bottom),
                    removal: .move(edge: .bottom)
                )
            )
        }
    }
    .ignoresSafeArea()
}
