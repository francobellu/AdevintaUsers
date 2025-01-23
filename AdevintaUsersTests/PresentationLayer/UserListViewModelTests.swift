import Testing
@testable import AdevintaUsers

@Suite("UserListViewModel Tests")
struct UserListViewModelTests {
    // Test constants
    static let mockUsers = [
        User.randomMock(),
        User.randomMock()
    ]

    // MARK: INIT

    @Test("test init: constant string properties have expected values")
    func test_constantStrings_haveExpectedValues() async throws {
        // Given
        let sut = await UserListViewModel(users: [])

        // Then
        try await #require(sut.deleteStr == "Delete")
        try await #require(sut.titleStr == "Adevinta Users")
        try await #require(sut.searchBarStr == "Search users")
        try await #require(sut.errorAlertStr == "Error")
    }

    @Test("test init: default properties have default values")
    func test_init_defaultPropertiesHaveDefaultValues() async throws {
        // Given / When
        let sut = await UserListViewModel(users: [])

        // Then
        try await #require(sut.isLoading == false)
        try await #require(sut.error == nil)
        try await #require(sut.searchTerm.isEmpty)
    }

    @Test("test_init_setsInitialUsers")
    func test_init_setsInitialUsers() async throws {
        // Given / When
        let sut = await UserListViewModel(users: Self.mockUsers)

        // Then
        try await #require(sut.users.count == 2)
        try await #require(sut.users[0].id.value == Self.mockUsers[0].id.value)
        try await #require(sut.users[1].id.value == Self.mockUsers[1].id.value)
    }

    @Test("test_init_withRandomMockUsers")
    func test_init_withRandomMockUsers() async throws {
        // Given / When
        let mockUsers = usersMocks(num: 50)
        let sut = await UserListViewModel(users: mockUsers)

        // Then
        try await #require(sut.users.count == 50) // usersMocks() creates 50 users
        try await #require(!sut.users.isEmpty)

        // Verify each user has valid data
        for user in await sut.users {
            try #require(!user.email.isEmpty)
            try #require(!user.id.value.isEmpty)
            try #require(!user.name.first.isEmpty)
            try #require(!user.name.last.isEmpty)
            try #require(!user.phone.isEmpty)
            try #require(!user.picture.large.isEmpty)
        }
    }

    // MARK: loadUsers

    @Test("test_loadUsers_setsIsLoadingToTrue")
    func test_loadUsers_setsIsLoadingToTrue() async throws {
        // Given
        let sut = await UserListViewModel(users: [])

        // When
        await sut.loadUsers()

        // Then
        try await #require(sut.isLoading == true)
    }

    @Test("test_loadUsers_whenCalled_printsLoadUsersMessage")
    func test_loadUsers_whenCalled_printsLoadUsersMessage() async throws {
        // Given
        let sut = await UserListViewModel(users: [])

        // When
        await sut.loadUsers()

        // Then
        // TODO:
    }

    // MARK: deleteUser

    @Test("test_deleteUser_whenCalled_printsDeleteUserMessage")
    func test_deleteUser_whenCalled_printsDeleteUserMessage() async throws {
        // Given
        let sut = await UserListViewModel(users: Self.mockUsers)
        let userToDelete = Self.mockUsers[0]

        // When
        await sut.deleteUser(userToDelete)

        // Then
        // TODO:
    }
}
