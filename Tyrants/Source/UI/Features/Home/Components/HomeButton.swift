import SwiftUI

struct HomeButtonDTO {
    let image: String
    let title: String
    let color: Color
    let textColor: Color
}

struct HomeButton: View {
    let dto: HomeButtonDTO
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Image(dto.image)
                    .resizable()
                    .frame(width: 150, height: 150)
                Text(dto.title)
                    .font(.tiny5(size: 40))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(dto.textColor)
                Spacer()
            }
            Spacer()
        }
        .padding(16)
        .background {
            Rectangle().fill(dto.color)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    VStack(spacing: 0) {
        HStack(spacing: 0) {
            HighlightableView {
                HomeButton(
                    dto: .init(
                        image: "news-icon",
                        title: "NEWS",
                        color: .purple,
                        textColor: .white
                    )
                )
            }
            HighlightableView {
                HomeButton(
                    dto: .init(
                        image: "map-icon",
                        title: "MAP",
                        color: .green,
                        textColor: .white
                    )
                )
            }
        }
        HStack(spacing: 0) {
            HighlightableView {
                HomeButton(
                    dto: .init(
                    image: "bag-icon",
                    title: "BAG",
                    color: .orange,
                    textColor: .white
                    )
                )
            }
        }
    }
}
