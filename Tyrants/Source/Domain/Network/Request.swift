import Foundation

enum RequestError: Error {
    case connection
    case client
    case server
    case parsing
    case unknown
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

protocol RequestProtocol {
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var body: Codable? { get }
}

enum Request: RequestProtocol {
    case login(req: LoginRequest)
    case news
    
    var endpoint: String {
        switch self {
        case .login:
            "/login"
        case .news:
            "/news"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
                .post
        case .news:
                .get
        }
    }
    
    var body: Codable? {
        switch self {
        case .login(let req):
            req
        default:
            nil
        }
    }
}
