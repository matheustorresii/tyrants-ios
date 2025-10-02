import SwiftUI

struct FloatingCloseButtonWrapper: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                FloatingCloseButton()
                    .padding(16)
            }
            Spacer()
        }
    }
}

struct FloatingCloseButton: View {
    
    @Environment(\.appCoordinator) var appCoordinator
    
    var body: some View {
        Button {
            appCoordinator.navigate(.pop)
        } label: {
            ZStack {
                Color.white
                Text("X")
                    .font(.tiny5(size: 52))
                    .foregroundStyle(.black)
                    .offset(x: 4)
            }
            .frame(width: 60, height: 60)
            .background {
                Color.black.offset(x: 4, y: 4)
            }
        }
    }
}

#Preview {
    FloatingCloseButtonWrapper()
}
