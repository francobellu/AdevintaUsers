import Foundation

protocol ApiClientProtocol: Sendable {
    func sendRequest<T: Decodable>(endpoint: any EndpointProtocol) async throws -> T
}
