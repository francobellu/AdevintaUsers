protocol DeleteUserUseCaseProtocol {
    func execute(_ user: User, users: [User]) -> [User]
}

enum DeleteUserUseCaseError: Error {
    case `internal`
}

