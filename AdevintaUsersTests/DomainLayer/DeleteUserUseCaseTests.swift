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

    @Test("test deletion of one user from a list of users reduces its size by one")
    func test_execute() async throws {
        // Given
        let users = User.randomMocks(num: 10)
        let user = users.first!
        userRepository.userStubs = .success([user])

        // When
        let result = sut.execute(user, users: users)

        // Them
        var newUsers = users
        let userIndex = newUsers.firstIndex(of: user)!
        newUsers.remove(at: userIndex)
        #expect(newUsers == result)
    }
}

