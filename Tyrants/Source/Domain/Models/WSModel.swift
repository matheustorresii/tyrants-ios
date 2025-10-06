import Foundation

// MARK: - IMAGE

struct WSImageModel: Codable {
    let image: String
    let fill: Bool?
}

// MARK: - JOIN

struct WSJoinModel: Codable {
    let join: String // tyrant-id
    let enemy: Bool
    
    init(
        join: String,
        enemy: Bool = false
    ) {
        self.join = join
        self.enemy = enemy
    }
}

struct WSJoinedModel: Codable {
    let joined: String // tyrant-id
    let enemy: Bool
    let turns: [WSTurnsModel]?
    
    init(
        joined: String,
        enemy: Bool = false,
        turns: [WSTurnsModel]? = nil
    ) {
        self.joined = joined
        self.enemy = enemy
        self.turns = turns
    }
}

struct WSLeaveModel: Codable {
    let leave: String // tyrant-id
}

struct WSLeftModel: Codable {
    let left: String // tyrant-id
    let turns: [WSTurnsModel]?
}

// MARK: - CLEAN

struct WSCleanModel: Codable {
    let clean: Bool
    let includeAllies: Bool?
    let turns: [WSTurnsModel]?
    
    init(
        clean: Bool,
        includeAllies: Bool? = nil,
        turns: [WSTurnsModel]? = nil
    ) {
        self.clean = clean
        self.includeAllies = includeAllies
        self.turns = turns
    }
}

// MARK: - VOTE

struct WSVoteModel: Codable {
    enum Model: String, Codable {
        case TO_PARTY, UNTIL_DEATH
    }
    let vote: Model
    let user: String // tyrant-id
}

struct WSVotingModel: Codable {
    struct Model: Codable {
        let toParty: Int
        let untilDeath: Int
        
        enum CodingKeys: String, CodingKey {
            case toParty = "TO_PARTY"
            case untilDeath = "UNTIL_DEATH"
        }
    }
    let voting: Model
}

// MARK: - UPDATE STATE

struct WSTyrantAttackModel: Codable {
    let name: String
    let fullPP: Int
    var currentPP: Int
}

struct WSTyrantsModel: Codable {
    let id: String // tyrant-id
    var asset: String
    var enemy: Bool
    var fullHp: Int
    var currentHp: Int
    var attacks: [WSTyrantAttackModel]
    
    init(
        id: String,
        asset: String,
        enemy: Bool = false,
        fullHp: Int,
        currentHp: Int,
        attacks: [WSTyrantAttackModel]
    ) {
        self.id = id
        self.asset = asset
        self.enemy = enemy
        self.fullHp = fullHp
        self.currentHp = currentHp
        self.attacks = attacks
    }
}

struct WSFinishedBattleModel: Codable {
    enum Model: String, Codable {
        case win = "WIN"
        case defeat = "DEFEAT"
    }
    let updateState: Model
}

struct WSUpdateStateModel: Codable {
    let turns: [WSTurnsModel]
    let updateState: UpdateState

    struct UpdateState: Codable {
        let lastAttack: WSAttackModel.Model?
        let tyrants: [WSTyrantsModel]
    }
}

// MARK: - ATTACK

struct WSAttackModel: Codable {
    struct Model: Codable {
        let user: String // tyrant-id
        let target: String // tyrant-id
        let attack: String
    }
    let attack: Model
}

// MARK: - BATTLE

struct WSTurnsModel: Codable {
    let id: String // tyrant-id
    let asset: String
    let enemy: Bool
}

struct WSBattleModel: Codable {
    let battle: String // tyrant-id
    let voteEnabled: Bool
    
    init(
        battle: String,
        voteEnabled: Bool = false
    ) {
        self.battle = battle
        self.voteEnabled = voteEnabled
    }
}

struct WSBattleStartedModel: Codable {
    struct Model: Codable {
        let toParty: Int
        let untilDeath: Int
        
        enum CodingKeys: String, CodingKey {
            case toParty = "TO_PARTY"
            case untilDeath = "UNTIL_DEATH"
        }
    }
    let battle: String // tyrant-id
    var turns: [WSTurnsModel]
    var tyrants: [WSTyrantsModel]
    let voting: Model?
}
