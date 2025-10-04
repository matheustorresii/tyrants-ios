import SwiftUI

struct NewsCard: View {
    let dto: NewsModel
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.9).ignoresSafeArea()
            Color.black.opacity(0.2).ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                Text(dto.title)
                    .font(.tiny5(size: 32))
                    .foregroundStyle(Color.white)
                Spacer().frame(height: 4)
                Image(dto.image.rawValue)
                    .resizable()
                    .offset(x: -2, y: -2)
                    .scaledToFill()
                    .background {
                        Rectangle().fill(Color.black)
                            .offset(x: 2, y: 2)
                    }
                Spacer().frame(height: 8)
                Text(dto.content)
                    .lineSpacing(4)
                    .font(.pressStart(size: 12))
                    .foregroundStyle(Color.white)
                Spacer().frame(height: 8)
                Rectangle()
                    .fill(.white)
                    .frame(height: 1)
                Spacer().frame(height: 8)
                HStack {
                    Text(dto.date)
                        .font(.tiny5(size: 12))
                        .foregroundStyle(Color.white)
                    Spacer()
                    if let category = dto.category {
                        Text(category)
                            .font(.tiny5(size: 12))
                            .foregroundStyle(Color.white)
                    }
                }
            }
            .padding(16)
        }
        .background {
            Rectangle().fill(Color.black)
                .offset(x: 8, y: 8)
        }
        .padding(16)
    }
}

#Preview {
    let dto = NewsModel(
        id: "1",
        image: .midas_signing,
        title: "Midas assina com o Real Madrid",
        content: "O jovem atacante Midas, destaque da base do Cruzeiro, acaba de ser contratado pelo Real Madrid. Com apenas 17 anos, o brasileiro promete agitar o mercado e seguir os passos de grandes talentos como Vinícius Júnior e Raphinha.",
        date: "17:59 - 20 de julho de 2021",
        category: "Esporte"
    )
    ZStack {
        Color.gray.ignoresSafeArea()
        ScrollView {
            VStack(spacing: 0) {
                NewsCard(dto: dto)
                NewsCard(dto: dto)
                NewsCard(dto: dto)
                NewsCard(dto: dto)
            }
        }
    }
}
