import Foundation
@testable import AdevintaUsers

class MockHttpClient: HTTPClientProtocol,  @unchecked Sendable {
    var data: Data?
    var response: URLResponse?
    var error: HTTPClientError?
    var lastRequest: URLRequest?

    init() {}

    func sendRequest(_ request: URLRequest) async throws -> Data {
        let result: Data
        lastRequest = request

        if let error = error {
            throw error
        }
        if let data = data, let _ = response as? HTTPURLResponse {
            return data
        } else {
            result = loadMockData(fromFile: "Users")
        }
        return result
    }
}

