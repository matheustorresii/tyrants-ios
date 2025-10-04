import SwiftUI

struct NewsScreen: View {
    @ObservedObject private var viewModel: NewsViewModel = .init()
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "NEWS")
            ZStack {
                Color.yellow.opacity(0.5).ignoresSafeArea()
                Color.black.opacity(0.5).ignoresSafeArea()
                makeBody()
                    .onAppear {
                        viewModel.fetchNews()
                    }
            }
        }
    }
    
    @ViewBuilder
    private func makeBody() -> some View {
        switch viewModel.state {
        case .loading:
            makeLoading()
        case .error:
            makeError()
        case .content(let news):
            makeContent(news)
        }
    }
    
    @ViewBuilder
    private func makeLoading() -> some View {
        ProgressView()
            .scaleEffect(5)
            .tint(.yellow)
    }
    
    @ViewBuilder
    private func makeContent(_ news: [NewsModel]) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(news, id: \.id) { item in
                    NewsCard(dto: item)
                }
            }
        }
    }
    
    @ViewBuilder
    private func makeError() -> some View {
        Text("Erro, xinga o torres")
            .font(.tiny5(size: 20))
    }
}

#Preview {
    NewsScreen()
}
