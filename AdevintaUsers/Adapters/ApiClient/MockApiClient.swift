import Foundation

final class MockApiClient: ApiClientProtocol, @unchecked Sendable {
    var mockData: [String: Any] = [:]
    var mockError: (any Error)?
    private(set) var lastEndpoint: (any EndpointProtocol)?

    init() {}
    func sendRequest<T: Decodable>(endpoint: any EndpointProtocol, method: HTTPMethod) async throws -> T {
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
