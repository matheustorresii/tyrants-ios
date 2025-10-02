import SwiftUI

struct MapScreen: View {
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "MAP")
            ZStack {
                Color.gray.opacity(0.3).ignoresSafeArea()
                MapView()
            }
        }
    }
}

#Preview {
    MapScreen()
}
