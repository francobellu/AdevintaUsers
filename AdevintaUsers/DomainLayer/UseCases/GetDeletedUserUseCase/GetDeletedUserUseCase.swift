final class GetDeletedUserUseCase: GetDeletedUserUseCaseProtocol {
    let userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    func execute(users: [User]) -> [User] {
        users.filter { $0.isBlacklisted }
    }
}
