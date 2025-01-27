import Foundation
@testable import AdevintaUsers
import Testing
@Suite("ApiClientIntegrationTests")
struct ApiClientIntegrationTests {
    let sut: ApiClient
    init() {
        let jsonDecoder = JSONDecoder()
        let jsonEncoder = JSONEncoder()
        let urlSession = URLSession.shared
        let httpRequestTimeoutInterval = 10.0
        let httpClientConfiguration = HTTPClientConfiguration(
            defaultHeaders: [:],
            timeoutInterval: httpRequestTimeoutInterval,
            cachePolicy: .useProtocolCachePolicy
        )
        let httpClient = HTTPClient(urlSession: urlSession, configuration: httpClientConfiguration)
        let apiClientConfiguration = ApiClientConfiguration.default()
        sut = ApiClient(
            configuration: apiClientConfiguration,
            httpClient: httpClient,
            jsonDecoder: jsonDecoder,
            jsonEncoder: jsonEncoder
        )
    }
    // MARK: - fetchUsers
    @Test("test fetchUsers uses correct endpoint")
    func test_sendRequest() async throws {
        // Given
        let endpoint = UsersEndpoint.getUsers(batchSize: 10)
        // When
        let usersResponseDTO: UsersResponseDTO = try await sut.sendRequest(endpoint: endpoint)
        print ("usersResponseDTO: \(usersResponseDTO)")
        // Then
        #expect(usersResponseDTO.results.count > 0)
    }
}
