@testable import AdevintaUsers
import Testing
import Foundation

@Suite("UserRepository Tests")
struct UserRepositoryTests {
    let sut: UserRepository
    let mockApiClient: MockApiClient

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
        _ = try? await sut.getUsers()

        // Then
        let endpoint = try #require(mockApiClient.lastEndpoint as? UsersEndpoint)
        #expect(endpoint == .getUsers)
    }

    @Test("test_fetchUsers_returnsUsers")
    func test_fetchUsers_getsUsers() async throws {
        // Given
        let users = User.randomMocks(num: 10)
        let usersDTOs = users.map(UserDTO.init)
        let responseDTO: UsersResponseDTO = .init(results: usersDTOs, info: InfoDTO(results: 2, page: 1))

        mockApiClient.setMockData(responseDTO, for: UsersEndpoint.getUsers)

        // When
        let result: [User] = try! await sut.getUsers()

        // Then
        #expect(result == users)
    }

    @Test("test_fetchUsers_throwsNetworkingError")
    func test_fetchUsers_throwsNetworkingError() async {
        // Given
        mockApiClient.mockError = ApiClientError.networkError

        // Then
        await #expect(throws: ApiClientError.networkError) {
            _ = try await sut.getUsers()
        }
    }
}



