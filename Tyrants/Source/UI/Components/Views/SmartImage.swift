import SwiftUI

struct SmartImage: View {
    let source: String
    
    var body: some View {
        Group {
            if let url = URL(string: source), url.scheme != nil {
                // É uma URL -> carrega remotamente
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                // É o nome de uma imagem local
                Image(source)
                    .resizable()
                    .scaledToFill()
            }
        }
    }
    
    private var placeholder: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFill()
            .foregroundStyle(.gray)
            .opacity(0.6)
            .padding()
    }
}

#Preview {
    VStack(spacing: 20) {
        SmartImage(source: "news-dex-show") // imagem local
        SmartImage(source: "https://picsum.photos/200") // imagem remota
        SmartImage(source: "inexistente") // placeholder
    }
    .padding()
}
