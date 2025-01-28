import Foundation

final class MockApiClient: ApiClientProtocol, @unchecked Sendable {
    var mockData: [String: Any] = [:]
    var mockError: (any Error)?
    var isSendRequestCalled = false
    private(set) var lastEndpoint: (any EndpointProtocol)?

    init() {}
    func sendRequest<T: Decodable>(endpoint: any EndpointProtocol) async throws -> T {
        isSendRequestCalled = true
        lastEndpoint = endpoint

        if let error = mockError {
            throw error
        }

        guard let data = mockData[endpoint.path] as? T else {
            throw URLError(.badServerResponse)
        }

        return data
    }

    func setMockData<T: Encodable>(_ data: T, for endpoint: any EndpointProtocol) {
        mockData[endpoint.path] = data
    }

    func setMockError(_ error: any Error) {
        mockError = error
    }
}
