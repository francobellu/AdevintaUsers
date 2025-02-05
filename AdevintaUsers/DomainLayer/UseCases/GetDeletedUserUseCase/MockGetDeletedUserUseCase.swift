final class MockGetDeletedUserUseCase: GetDeletedUserUseCaseProtocol {
    func execute(users: [User]) -> [User] {
        []
    }
}
