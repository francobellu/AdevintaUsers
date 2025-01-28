import Foundation

enum UsersEndpoint: EndpointProtocol {
    case getUsers(batchSize: Int)

    var method: String {
        switch self {
        case .getUsers:
            return "GET"
        }
    }

    var path: String {
        switch self {
        case .getUsers:
            return "/"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .getUsers(let batchSize):
            guard let _ = Int(String(describing: batchSize)) else {
                return nil
            }
            return [
                URLQueryItem(name: "results", value: String(describing: batchSize)),
                URLQueryItem(name: "seed", value: String(describing: "foobar"))
            ]
        }
    }
}
