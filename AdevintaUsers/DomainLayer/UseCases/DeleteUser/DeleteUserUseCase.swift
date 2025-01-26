//
//  DeleteUserUseCaseProtocol 2.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 26/1/25.
//

class DeleteUserUseCase: DeleteUserUseCaseProtocol {
    func execute(_ user: User, users: [User]) async throws -> [User] {
        var result = users
        result.removeAll { $0.id == user.id}
        // TODO: remove also from persistence when implemented
        return result
    }
}
