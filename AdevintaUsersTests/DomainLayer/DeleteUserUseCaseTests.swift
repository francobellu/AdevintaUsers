@testable import AdevintaUsers
import Testing

@Suite("DeleteUserUseCase Tests")
struct DeleteUserUseCaseTests {
    let sut: DeleteUserUseCase

    init() {
        sut = DeleteUserUseCase()
    }

    @Test("test deletion of one user from a list of users reduces its size by one")
    func test_execute() async throws {
        // Given
        let users = User.randomMocks(num: 10)
        let user = users.first!

        // When
        let result = sut.execute(user, users: users)

        // Them
        #expect(result.count == 9)
    }
}

