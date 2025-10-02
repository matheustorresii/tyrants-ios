import SwiftUI

struct WiggleModifier: ViewModifier {
    var range: CGFloat
    var speed: Double
    
    @State private var offset: CGSize = .zero
    
    func body(content: Content) -> some View {
        content
            .offset(offset)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { _ in
                    withAnimation(.linear(duration: speed)) {
                        offset = .init(
                            width: .random(in: -range...range),
                            height: .random(in: -range...range)
                        )
                    }
                }
            }
    }
}

extension View {
    func wiggle(range: CGFloat = 1, speed: Double = 0.5) -> some View {
        modifier(WiggleModifier(range: range, speed: speed))
    }
}
