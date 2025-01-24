import Testing
@testable import AdevintaUsers

@MainActor
@Suite("UserListViewModel Search Tests")
struct UserListViewModelSearchTests {
    let sut: UserListViewModel
    var fetchUsersUseCase: MockFetchUsersUseCase!
    var deleteUserUseCase: MockDeleteUserUseCase!
    var mockUsers: [User]!

    let usersStubCount = 3

    init() {
        // Setup mock useCases
        fetchUsersUseCase = MockFetchUsersUseCase()
        mockUsers = User.randomMocks(num: usersStubCount)
        fetchUsersUseCase.usersResultStub = .success(mockUsers)
        deleteUserUseCase = MockDeleteUserUseCase()

        sut = UserListViewModel(
            fetchUsersUseCase: fetchUsersUseCase,
            deleteUserUseCase: deleteUserUseCase
        )
    }

    @MainActor
    @Test("test filteredUsers: empty search text returns all users")
    func test_filteredUsers_emptySearchText_returnsAllUsers() async throws {
        // Given
        await sut.loadUsers()

        // When
        sut.searchTerm = ""

        // Then
        guard case let .success(users) = sut.asyncOp else {
            try #require(Bool(false), "asyncOp need to be .success in order to contain users to filter")
            return
        }
        #expect(sut.filteredUsers?.count == usersStubCount)
        #expect(sut.filteredUsers == users)
    }

    @MainActor
    @Test("test filteredUsers: searching by first name returns matching users")
    func test_filteredUsers_matchingFirstName_returnsFilteredUsers() async throws {
        // Given
        let targetUser = mockUsers[0]
        await sut.loadUsers()

        // When
        sut.searchTerm = targetUser.name.first

        // Then
        guard let filteredUsers = sut.filteredUsers else {
            try #require(Bool(false), "filteredUsers should not be nil")
            return
        }
        #expect(filteredUsers.contains { $0.id == targetUser.id })
    }

    @MainActor
    @Test("test filteredUsers: searching by last name returns matching users")
    func test_filteredUsers_matchingLastName_returnsFilteredUsers() async throws {
        // Given
        let targetUser = mockUsers[0]
        await sut.loadUsers()

        // When
        sut.searchTerm = targetUser.name.last

        // Then
        guard let filteredUsers = sut.filteredUsers else {
            try #require(Bool(false), "filteredUsers should not be nil")
            return
        }
        #expect(filteredUsers.contains { $0.id == targetUser.id })
    }

    @MainActor
    @Test("test filteredUsers: searching by email returns matching users")
    func test_filteredUsers_matchingEmail_returnsFilteredUsers() async throws {
        // Given
        let targetUser = mockUsers[0]
        await sut.loadUsers()

        // When
        sut.searchTerm = targetUser.email.prefix(5).lowercased()

        // Then
        guard let filteredUsers = sut.filteredUsers else {
            try #require(Bool(false), "filteredUsers should not be nil")
            return
        }
        #expect(filteredUsers.contains { $0.id == targetUser.id })
    }

    @MainActor
    @Test("test filteredUsers: non-matching search returns empty array")
    func test_filteredUsers_noMatches_returnsEmptyArray() async throws {
        // Given
        await sut.loadUsers()

        // When
        sut.searchTerm = "NonexistentUserXYZ123"

        // Then
        guard let filteredUsers = sut.filteredUsers else {
            try #require(Bool(false), "filteredUsers should not be nil")
            return
        }
        #expect(filteredUsers.isEmpty)
    }
}
