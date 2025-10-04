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
    let mock: [NewsModel] = [
        NewsModel(
            id: "1",
            image: .midas_signing,
            title: "Midas assina com o Real Madrid",
            content: "O jovem atacante Midas, destaque da base do Cruzeiro, acaba de ser contratado pelo Real Madrid. Com apenas 17 anos, o brasileiro promete agitar o mercado e seguir os passos de grandes talentos como Vinícius Júnior e Raphinha.",
            date: "17:59 - 20 de julho de 2021",
            category: "Esporte"
        ),
        NewsModel(
            id: "2",
            image: .rosa_handshake,
            title: "Rosa assina contrato bilionário",
            content: "A visionária diretora Rosa acaba de fechar um contrato histórico, unindo sua empresa a uma sociedade estratégica que a posiciona como líder absoluta do mercado nacional. Este movimento promete revolucionar o setor e consolidar sua influência no país.",
            date: "17:59 - 20 de julho de 2021",
            category: "Negócios"
        ),
        NewsModel(
            id: "3",
            image: .dex_show,
            title: "DEX encerra turnê no Brasil",
            content: "A banda DEX finalizou sua turnê pelo Brasil com shows memoráveis e, com isso, alcançou o recorde de maior número de seguidores e streams no Spotify entre bandas de rock. O grupo consolida seu lugar na história da música nacional e internacional.",
            date: "17:59 - 20 de julho de 2021",
            category: "Música"
        ),
        NewsModel(
            id: "4",
            image: .tumba_fight,
            title: "Tumba conquista o mundial de MMA",
            content: "O lutador Tumba completou um ano invicto em sua carreira profissional e acaba de conquistar o título mundial de MMA. Com técnicas impressionantes e uma força extraordinária, ele se firma como uma lenda no esporte.",
            date: "17:59 - 20 de julho de 2021",
            category: "Esporte"
        )
    ]
    ZStack {
        Color.gray.ignoresSafeArea()
        ScrollView {
            VStack(spacing: 0) {
                ForEach(mock, id: \.id) {
                    NewsCard(dto: $0)
                }
            }
        }
    }
}
