final class FetchUsersUseCase: FetchUsersUseCaseProtocol {
    let userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    func execute(batchSize: Int, initialLoad: Bool = false) async throws -> [User] {
        try await userRepository.fetchUsers(batchSize: batchSize, initialLoad: initialLoad)
    }
}
