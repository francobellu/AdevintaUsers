import Foundation

protocol EndpointProtocol: Hashable {
    var method: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}
