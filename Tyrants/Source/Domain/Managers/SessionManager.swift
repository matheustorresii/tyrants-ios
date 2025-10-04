import Foundation

final class SessionManager {
    var login: LoginModel?
    
    init(login: LoginModel? = nil) {
        self.login = login
    }
}
