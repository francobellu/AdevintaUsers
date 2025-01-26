//
//  FetchUsersUseCase.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 26/1/25.
//

class FetchUsersUseCase: FetchUsersUseCaseProtocol {
    let userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    func execute(batchSize: Int, page: Int) async throws -> [User] {
        try await userRepository.fetchUsers(batchSize: batchSize, page: page)
    }
}
