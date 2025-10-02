import SwiftUI

enum LaunchScreenState {
    case loading
    case loggedIn(String)
    case loggedOut
}

struct LaunchScreen: View {
    @Environment(\.appCoordinator) var appCoordinator
    @Environment(\.dataPersistence) var dataPersistenceManager
    @ObservedObject private var viewModel: LaunchViewModel = .init()
    @State private var currentIndex = 0
    @State var loggedOutText: String = ""
    private let timer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            makeText()
                .padding(16)
        }
        .foregroundStyle(.green)
        .onAppear {
            if let userId = dataPersistenceManager.userId {
                viewModel.fetchUser(userId)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    viewModel.state = .loggedOut
                }
            }
        }
    }
    
    @ViewBuilder
    private func makeText() -> some View {
        switch viewModel.state {
        case .loading:
            makeLoadingBody()
                .font(.sixtyfour(size: 30))
        case .loggedIn(let name):
            makeLoggedInBody(name)
        case .loggedOut:
            makeLoggedOutBody()
                .font(.sixtyfour(size: 22))
        }
    }
    
    @ViewBuilder
    private func makeLoggedInBody(_ name: String) -> some View {
        VStack(alignment: .center, spacing: 2) {
            Text("Hello,")
                .font(.sixtyfour(size: 30))
            Text(name)
                .font(.sixtyfour(size: 22))
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if name.uppercased() == "DAVID-BECKHAM" {
                    appCoordinator.navigate(.replace(.home))
                }
            }
        }
    }
    
    @ViewBuilder
    private func makeLoggedOutBody() -> some View {
        HStack {
            TextField("", text: $loggedOutText)
                .padding(10)
                .background(Color.black)
                .foregroundStyle(.white)
                .tint(.green)
                .overlay {
                    Rectangle().stroke(Color.white, lineWidth: 1)
                }
                .clipShape(Rectangle())
            
            Button {
                viewModel.fetchUser(loggedOutText)
            } label: {
                ZStack {
                    Color.black
                    Text(">")
                        .font(.tiny5(size: 32))
                        .foregroundStyle(.green)
                        .offset(x: 4)
                }
                .overlay {
                    Rectangle().stroke(Color.green, lineWidth: 1)
                }
                .frame(width: 44, height: 44)
            }
        }
    }
    
    @ViewBuilder
    private func makeLoadingBody() -> some View {
        let text = "Loading"
        
        HStack(spacing: 2) {
            ForEach(Array(text.enumerated()), id: \.offset) { index, char in
                Text(String(char))
                    .animation(.linear(duration: 0.3), value: currentIndex)
                    .opacity(currentIndex == index ? 1 : 0.7)
                    .scaleEffect(currentIndex == index ? 1.2 : 1)
            }
        }
        .onReceive(timer) { _ in
            currentIndex = (currentIndex + 1) % text.count
        }
    }
}

#Preview {
    LaunchScreen()
}
