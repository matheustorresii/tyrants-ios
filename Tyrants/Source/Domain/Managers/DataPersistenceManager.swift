import Foundation

final class DataPersistenceManager {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    private let userIdKey = "USER_ID"
    
    var userId: String? {
        get {
            userDefaults.string(forKey: userIdKey)
        }
        set {
            userDefaults.set(newValue, forKey: userIdKey)
        }
    }
}
