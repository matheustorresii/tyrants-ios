import Foundation

struct LoginRequest: Codable {
    let id: String
}

struct LoginResponse: Codable {
    let id: String
    let name: String
    let tyrant: TyrantModel?
    let xp: Int?
    let items: [String]?
    let admin: Bool?
    
    init(
        id: String,
        name: String,
        tyrant: TyrantModel? = nil,
        xp: Int? = nil,
        items: [String]? = nil,
        admin: Bool? = nil
    ) {
        self.id = id
        self.name = name
        self.tyrant = tyrant
        self.xp = xp
        self.items = items
        self.admin = admin
    }
}
