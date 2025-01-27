import Foundation

/// Protocol defining the interface for an HTTP client.
/// Implementations of this protocol are responsible for sending HTTP requests.
protocol HTTPClientProtocol: Sendable {
    func sendRequest(_ request: URLRequest) async throws -> Data
}
