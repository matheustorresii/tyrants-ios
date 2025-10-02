import SwiftUI

struct NewsScreen: View {
    
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
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "NEWS")
            ZStack {
                Color.gray.opacity(0.3)
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(mock, id: \.id) { mock in
                            NewsCard(dto: mock)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NewsScreen()
}
