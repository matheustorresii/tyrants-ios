import SwiftUI

struct HighlightableView<Content: View>: View {
    
    @GestureState private var isPressed = false
    let action: (() -> Void)?
    let content: () -> Content
    
    init(action: (() -> Void)? = nil, content: @escaping () -> Content) {
        self.action = action
        self.content = content
    }
    
    var body: some View {
        content()
            .opacity(isPressed ? 0.6 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in
                        state = true
                    }
                    .onEnded { _ in
                        action?()
                    }
            )
    }
}
