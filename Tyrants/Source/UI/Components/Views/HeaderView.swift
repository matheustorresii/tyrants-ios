import SwiftUI

struct HeaderView: View {
    
    @Environment(\.appCoordinator) var appCoordinator
    
    let title: String
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 0) {
                Button {
                    appCoordinator.navigate(.pop)
                } label: {
                    Text("<")
                        .font(.tiny5(size: 44))
                        .foregroundStyle(Color.black)
                }
                .offset(x: 12)
                Spacer()
                Text(title)
                    .font(.tiny5(size: 44))
                Spacer()
            }
            Rectangle()
                .fill(.black)
                .frame(height: 2)
        }
    }
}

#Preview {
    VStack {
        HeaderView(title: "NEWS")
        Spacer()
    }
}
