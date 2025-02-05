final class DeleteUserUseCase: DeleteUserUseCaseProtocol {
    let userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    func execute(_ user: User, users: [User]) -> [User] {
        var newUsers = users
        if let userIndex = newUsers.firstIndex(of: user) {
            // Mark the user as deleted and update user's list in the repo
            newUsers[userIndex].isBlacklisted = true
            userRepository.updateUser(newUsers)
        }
        return newUsers
    }
}
