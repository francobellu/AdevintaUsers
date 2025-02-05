@testable import AdevintaUsers
import Testing

@Suite("DeleteUserUseCase Tests")
struct DeleteUserUseCaseTests {
    let sut: DeleteUserUseCase
    var userRepository: MockUserRepository!

    init() {
        userRepository = MockUserRepository()
        sut = DeleteUserUseCase(userRepository: userRepository)
    }

    @Test("test deletion of one user from a list of users returns a new list with the user markes as deleted")
    func test_execute() async throws {
        // Given
        let users = User.randomMocks(num: 10)
        let userToDelete = users.first!

        // When
        let result = sut.execute(userToDelete, users: users)

        // Them
        let userIndex = result.firstIndex(of: userToDelete)!
        let user = result[userIndex]
        #expect(user.isBlacklisted == true, "User should be deleted")
    }
}

