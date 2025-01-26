import Foundation
@testable import AdevintaUsers
import Testing

@Suite("APICLientIntegrationTests")
struct ApiClientIntegrationTests {
    let sut: ApiClient
    init() {
        let jsonDecoder = JSONDecoder()
        let jsonEncoder = JSONEncoder()
        let urlSession = URLSession.shared
        let configuration = HTTPClientConfiguration.default
        let httpClient = HTTPClient(urlSession: urlSession, configuration: configuration)
        let apiClientConfiguration = ApiClientConfiguration.default()
        sut =  ApiClient(
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
        let endpoint = UsersEndpoint.getUsers

        // When
        let usersResponseDTO: UsersResponseDTO = try await sut.sendRequest(endpoint: endpoint, method: .get)
        print ("usersResponseDTO: \(usersResponseDTO)")

        // Then
        #expect(usersResponseDTO.results.count > 0)
    }
}
