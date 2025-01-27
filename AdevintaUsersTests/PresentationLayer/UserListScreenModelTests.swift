import Testing
@testable import AdevintaUsers

@MainActor
@Suite("UserListScreenModel Tests")
struct UserListScreenModelTests {
    let sut: UserListScreenModel
    var fetchUsersUseCase: MockFetchUsersUseCase!
    var deleteUserUseCase: MockDeleteUserUseCase!
    var removeDuplicatedUsersUseCase: RemoveDuplicatedUsersUseCase

    var resultUsersStub: Result<[User], UserListScreenModelError>

    let usersStubCount = 10
    let userStub: User = User.randomMock()
    let usersPerBatch = 7

    init ()  {
        // Setup mock useCases
        resultUsersStub = .success(User.randomMocks(num: usersStubCount))
        fetchUsersUseCase = MockFetchUsersUseCase()
        fetchUsersUseCase.usersResultStub = resultUsersStub
        
        deleteUserUseCase = MockDeleteUserUseCase()
        removeDuplicatedUsersUseCase = RemoveDuplicatedUsersUseCase()

        sut = UserListScreenModel(
            usersPerBatch: usersPerBatch,
            fetchUsersUseCase: fetchUsersUseCase,
            deleteUserUseCase: deleteUserUseCase,
            removeDuplicatedUsersUseCase: removeDuplicatedUsersUseCase
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

    @Test("test loadUsers(): test users is not nil and not empty")
    func test_loadUsers_asyncOpIsSuccessWithUsers() async throws {
        // Given / When
        await sut.loadUsers()

        // Then
        #expect(sut.users != nil, "the returned users should not be nil and not empty")
        #expect(!sut.users.isEmpty, "the returned users should not be empty")
    }

    @Test("test loadUsers(): test asyncOp is .loadingFailure")
    mutating func test_loadUsers_asyncOpIsLoadingFailure() async throws {
        // Given
        fetchUsersUseCase.usersResultStub = .failure(UserListScreenModelError.loadingFailure)

        // When
        await sut.loadUsers()

        // Then
        guard case let .failed(error) = sut.asyncOp else {
            #expect(Bool(false), "the asyncOp should be .loadingFailure"); return
        }

        guard case UserListScreenModelError.loadingFailure = error else {
            #expect(Bool(false), "the error should be .loadingFailure"); return
        }
    }

    // MARK: deleteUser
    
    @Test("test deleteUser(): test the user is deleted")
    func test_deleteUser_deleteUser() async throws {
        // Given
        await sut.loadUsers()

        try #require(sut.users.count == usersStubCount, "the returned users should have \(usersStubCount) elements")

        // When
        let userToDelete = sut.users.first!
        await sut.deleteUser(userToDelete)

        // Then
        #expect(sut.users.count == usersStubCount - 1, "the user should be deleted")
    }
}
