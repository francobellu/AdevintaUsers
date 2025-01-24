import Testing
@testable import AdevintaUsers

@MainActor
@Suite("UserListViewModel Tests")
struct UserListViewModelTests {
    let sut: UserListViewModel
    var fetchUsersUseCase: MockFetchUsersUseCase!
    var deleteUserUseCase: MockDeleteUserUseCase!

    var resultUsersStub: Result<[User], UserListViewModelError>

    let usersStubCount = 10
    let userStub: User = User.randomMock()

    init ()  {
        // Setup mock useCases
        resultUsersStub = .success(User.randomMocks(num: usersStubCount))
        fetchUsersUseCase = MockFetchUsersUseCase()
        fetchUsersUseCase.usersResultStub = resultUsersStub

        deleteUserUseCase = MockDeleteUserUseCase()

        sut = UserListViewModel(
            fetchUsersUseCase: fetchUsersUseCase,
            deleteUserUseCase: deleteUserUseCase
        )
    }

    // MARK: INIT

    @Test("test init(): test constant string properties are properly initialized")
    func test_constantStrings_haveExpectedValues() async throws {
        // Given

        // Then
        #expect(sut.deleteStr == "Delete")
        #expect(sut.titleStr == "Adevinta Users")
        #expect(sut.searchBarStr == "Search users")
        #expect(sut.errorAlertStr == "Error")
    }

    @Test("test init(): test default properties are initialized with default values")
    func test_init_defaultPropertiesHaveDefaultValues() async throws {
        // Given / When

        // Then
        #expect(sut.searchTerm.isEmpty)
        #expect(sut.selectedUser == nil)
    }

    @Test("test init(): test sut is initialized with nil asyncOp")
    func test_init_asyncOpIsNil() async throws {
        // Given / When

        // Then
        #expect(sut.asyncOp == nil, "sut should be initialized with empty asyncOp")
    }

    // MARK: loadUsers
    @Test("test loadUsers(): test asyncOp is inProgress")
    func test_loadUsers_asyncOpIsInProgress() async throws {
        // Given / When
        Task {
            await sut.loadUsers()
        }

        // Then
        Task {
            #expect(sut.asyncOp == .inProgress)
        }
    }

    @Test("test loadUsers(): test asyncOp is .success and contains users")
    func test_loadUsers_asyncOpIsSuccessWithUsers() async throws {
        // Given / When
        await sut.loadUsers()

        // Then
        guard case let .success(result: users) = sut.asyncOp,
              let users else {
            #expect(Bool(false), "the asyncOp should be .success"); return
        }
        
        try #require(users != nil,"the returned users should not be nil")
        #expect(!users.isEmpty,"the returned users should not be empty")

        // Verify each user has valid data
        for i in 0 ..< usersStubCount {
            guard case let .success(resultUsers) = resultUsersStub else {
                #expect(Bool(false), "the asyncOp should be .success"); return
            }
            #expect(users[i] == resultUsers[i])
        }
    }

    @Test("test loadUsers(): test asyncOp is .loadingFailure")
    mutating func test_loadUsers_asyncOpIsLoadingFailure() async throws {
        // Given
        fetchUsersUseCase.usersResultStub = .failure(UserListViewModelError.loadingFailure)

        // When
        await sut.loadUsers()

        // Then
        guard case let .failed(error) = sut.asyncOp else {
            #expect(Bool(false), "the asyncOp should be .loadingFailure"); return
        }

        guard case UserListViewModelError.loadingFailure = error else {
            #expect(Bool(false), "the error should be .loadingFailure"); return
        }
    }

    // MARK: deleteUser
    
    @Test("test deleteUser(): test the user is deleted")
    func test_deleteUser_deleteUser() async throws {
        // Given
        await sut.loadUsers()
        guard case let .success(result: users) = sut.asyncOp,
              let users else {
                try #require(Bool(false), "the asyncOp should be .success"); return
        }

        try #require(users.count == usersStubCount, "the returned users should have \(usersStubCount) elements")

        // When
        let userToDelete = users.first!
        await sut.deleteUser(userToDelete)

        guard case let .success(result: users) = sut.asyncOp,
              let users else {
            #expect(Bool(false), "the asyncOp should be .success"); return
        }

        // Then
        #expect(users.count == usersStubCount - 1, "the user should be deleted")
    }

    @Test("test deleteUser(): test UserListViewModelError.deletionFailed error")
    mutating func test_deleteUser_failsWithDeletionFailed () async throws {
        // Given
        await sut.loadUsers()
        guard case let .success(result: users) = sut.asyncOp,
              let users else {
                try #require(Bool(false), "the asyncOp should be .success"); return
        }

        try #require(users.count == usersStubCount, "the returned users should have \(usersStubCount) elements")

        let userToDelete = users.first!
        deleteUserUseCase.errorStub = .internal


        // When
        await sut.deleteUser(userToDelete)

        guard case let .failed(error) = sut.asyncOp else {
            #expect(Bool(true), "the asyncOp should be .failed"); return
        }

        // Then
        #expect(error as! UserListViewModelError == UserListViewModelError.deletionFailed, "the error should be UserListViewModelError.deletionFailed")
        #expect(users.count == usersStubCount, "the user should be deleted")
    }
}
