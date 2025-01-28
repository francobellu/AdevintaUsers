@testable import AdevintaUsers
import Testing
import Foundation

@Suite("UserRepository Tests")
struct UserRepositoryTests {
    let sut: UserRepository
    let mockApiClient: MockApiClient

    let batchSize = 2, page = 1
    let userEndpoint = UsersEndpoint.getUsers(batchSize: 2)

    init() {

        mockApiClient = MockApiClient()
        sut = UserRepository(
            apiClient: mockApiClient
        )
    }

    // MARK: - fetchUsers

    @Test("test fetchUsers uses correct endpoint")
    func test_fetchUsers_usesCorrectEndpoint() async throws {
        // When
        _ = try? await sut.fetchUsers(batchSize: batchSize)

        // Then
        let endpoint = try #require(mockApiClient.lastEndpoint as? UsersEndpoint)
        #expect(endpoint == userEndpoint)
    }

    @Test("test_fetchUsers_returnsUsers")
    func test_fetchUsers_getsUsers() async throws {
        // Given
        let users = User.randomMocks(num: 10)
        let usersDTOs = users.map(UserDTO.init)
        let responseDTO: UsersResponseDTO = .init(results: usersDTOs, info: InfoDTO(results: batchSize))

        let endpoint = UsersEndpoint.getUsers(batchSize: 10)
        mockApiClient.setMockData(responseDTO, for: endpoint)

        // When
        let result: [User] = try! await sut.fetchUsers(batchSize: batchSize)

        // Then
        #expect(result == users)
    }

    @Test("test_fetchUsers_throwsNetworkingError")
    func test_fetchUsers_throwsNetworkingError() async {
        // Given
        mockApiClient.mockError = ApiClientError.networkError

        // Then
        await #expect(throws: ApiClientError.networkError) {
            _ = try await sut.fetchUsers(batchSize: batchSize)
        }
    }
}



