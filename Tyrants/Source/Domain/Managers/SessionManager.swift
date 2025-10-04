import Foundation

final class SessionManager {
    var login: LoginResponse?
    
    init(login: LoginResponse? = nil) {
        self.login = login
    }
}
