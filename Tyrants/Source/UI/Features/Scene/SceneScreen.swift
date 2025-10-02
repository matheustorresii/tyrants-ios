import SwiftUI

struct SceneScreen: View {
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).ignoresSafeArea()
            FloatingCloseButtonWrapper()
            Text("Scene")
        }
    }
}

#Preview {
    SceneScreen()
}
