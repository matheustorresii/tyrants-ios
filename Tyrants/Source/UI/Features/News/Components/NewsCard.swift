import SwiftUI

struct NewsCard: View {
    let dto: NewsModel
    
    var body: some View {
        ZStack {
            Color.white
            VStack(alignment: .leading, spacing: 0) {
                Text(dto.title)
                    .font(.tiny5(size: 32))
                    .foregroundStyle(Color.black)
                Spacer().frame(height: 4)
                Image(dto.image.rawValue)
                    .resizable()
                    .scaledToFill()
                Spacer().frame(height: 4)
                Text(dto.content)
                    .lineSpacing(4)
                    .font(.pressStart(size: 12))
                Spacer().frame(height: 4)
                HStack {
                    Text(dto.date)
                        .font(.tiny5(size: 12))
                        .foregroundStyle(Color.gray)
                    Spacer()
                    if let category = dto.category {
                        Text(category)
                            .font(.tiny5(size: 12))
                            .foregroundStyle([
                                Color.blue, Color.purple, Color.red
                            ].randomElement() ?? Color.gray)
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
