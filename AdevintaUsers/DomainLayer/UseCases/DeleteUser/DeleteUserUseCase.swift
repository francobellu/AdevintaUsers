final class DeleteUserUseCase: DeleteUserUseCaseProtocol {
    let userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    func execute(_ user: User, users: [User]) -> [User] {
        var result = users

        let userIndex = result.firstIndex(of: user)!
        result.remove(at: userIndex)

        userRepository.addToBlacklist(user: user)
        return result
    }
}
