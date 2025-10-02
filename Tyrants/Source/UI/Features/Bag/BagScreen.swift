import SwiftUI

struct BagScreen: View {
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).ignoresSafeArea()
            FloatingCloseButtonWrapper()
            Text("Bag")
        }
    }
}

#Preview {
    BagScreen()
}
