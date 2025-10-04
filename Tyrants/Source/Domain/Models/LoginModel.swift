import Foundation

struct LoginModel: Codable {
    let id: String
    let name: String
    let tyrant: TyrantModel
    let xp: Int?
    let items: [String]?
}
