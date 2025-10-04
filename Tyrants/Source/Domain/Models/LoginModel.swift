import Foundation

struct LoginRequest: Codable {
    let id: String
}

struct LoginResponse: Codable {
    let id: String
    let name: String
    let tyrant: TyrantModel
    let xp: Int?
    let items: [String]?
}
