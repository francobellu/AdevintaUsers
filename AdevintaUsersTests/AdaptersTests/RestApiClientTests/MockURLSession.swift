import Foundation
@testable import AdevintaUsers

final class MockURLSession: URLSessionProtocol, @unchecked Sendable {
    var data: Data?
    var response: URLResponse?
    var error: (any Error)?
    var lastRequest: URLRequest?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        lastRequest = request
        if let error = error {
            throw error
        }
        guard let data = data, let response = response else {
            throw NSError(domain: "MockURLSession", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data or response set"])
        }
        return (data, response)
    }
}
