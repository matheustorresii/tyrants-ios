import Foundation

struct TyrantModel: Codable {
    let id: String
    let nickname: String?
    let asset: String
    let evolutions: [String]?
    let attacks: [TyrantAttack]?
    let hp: Int
    let attack: Int
    let defense: Int
    let speed: Int
    
    init(
        id: String,
        nickname: String? = nil,
        asset: String,
        evolutions: [String]? = nil,
        attacks: [TyrantAttack]? = nil,
        hp: Int,
        attack: Int,
        defense: Int,
        speed: Int
    ) {
        self.id = id
        self.nickname = nickname
        self.asset = asset
        self.evolutions = evolutions
        self.attacks = attacks
        self.hp = hp
        self.attack = attack
        self.defense = defense
        self.speed = speed
    }
}

struct TyrantAttack: Codable {
    let name: String
    let power: Int
    let pp: Int
    let attributes: [TyrantAttackAttributes]?
}

enum TyrantAttackAttributes: String, Codable {
    case nerfAttack = "NERF_ATTACK"
    case nerfDef = "NERF_DEF"
}
