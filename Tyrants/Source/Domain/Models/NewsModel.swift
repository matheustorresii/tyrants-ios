import Foundation

enum NewsImage: String, Codable {
    case midas_signing = "news-midas-signing"
    case rosa_handshake = "news-rosa-handshake"
    case tumba_fight = "news-tumba-fight"
    case dex_show = "news-dex-show"
}

struct NewsModel: Codable {
    let id: String
    let image: NewsImage
    let title: String
    let content: String
    let date: String
    let category: String?
}
