@testable import AdevintaUsers
import Testing
import Foundation

@Suite("UserRepository Tests")
struct UserRepositoryTests {
    let sut: UserRepository
    let mockApiClient: MockApiClient
    let mockUserDefaultsAdapter: MockUserDefaultsAdapter

    let batchSize = 2, page = 1
    let userEndpoint: UsersEndpoint

    let usedResponseDTO: UsersResponseDTO
    let apiUsers: [User]

    init() {

        // Test Data
        userEndpoint = UsersEndpoint.getUsers(batchSize: batchSize)
        apiUsers = User.randomMocks(num: batchSize)
        let apiUsersDTOs = apiUsers.map(UserDTO.init)
        usedResponseDTO = UsersResponseDTO(results: apiUsersDTOs, info: InfoDTO(results: batchSize))

        mockApiClient = MockApiClient()
        mockUserDefaultsAdapter = MockUserDefaultsAdapter()
        sut = UserRepository(
            apiClient: mockApiClient,
            userDefaultsAdapter: mockUserDefaultsAdapter
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
        let endpoint = UsersEndpoint.getUsers(batchSize: 10)
        mockApiClient.setMockData(usedResponseDTO, for: endpoint)

        // When
        let result: [User] = try! await sut.fetchUsers(batchSize: batchSize)

        // Then
        #expect(result == apiUsers)
    }

    @Test("test_fetchUsers_throwsNetworkingError")
    func test_fetchUsers_throwsNetworkingError() async {
        // Given
        mockApiClient.mockError = ApiClientError.networkError

        // When/Then
        await #expect(throws: ApiClientError.networkError) {
            _ = try await sut.fetchUsers(batchSize: batchSize)
        }
    }

    @Test("test_fetchUsers_loadsUsersFromCache")   // TODO: rename fetch to load
    func test_fetchUsers_usersLoadedFromCache() async {
        // Given
        let cachedUsers = User.randomMocks(num: 10)
        let cachedUsersDTOs = cachedUsers.map{UserDTO(from: $0)}
        mockUserDefaultsAdapter.getUsersMock = cachedUsersDTOs

        // When
        let result: [User] = try! await sut.fetchUsers(batchSize: batchSize)

        // Then
        #expect(result == cachedUsers)
        #expect(mockApiClient.isSendRequestCalled == false) // API should not be called
    }

    @Test("test_fetchUsers_savesToCache_afterAPIFetch")
    func test_fetchUsers_savesToCache_afterAPIFetch() async throws {
        // Given
        mockApiClient.setMockData(usedResponseDTO, for: userEndpoint)

        // When
        _ = try await sut.fetchUsers(batchSize: 2)

        // Then
        let savedUsers: [User] = mockUserDefaultsAdapter.savedUsersMock.map{$0.toDomain()}

        #expect(savedUsers == apiUsers)
        #expect(mockUserDefaultsAdapter.lastUsedKey == .uniqueUsers)
    }
}


