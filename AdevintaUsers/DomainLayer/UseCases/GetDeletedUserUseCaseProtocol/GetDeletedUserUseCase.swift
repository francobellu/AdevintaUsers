final class GetDeletedUserUseCase: GetDeletedUserUseCaseProtocol {
    let userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    func execute() -> [User] {
        return userRepository.loadBlacklist()
    }
}
