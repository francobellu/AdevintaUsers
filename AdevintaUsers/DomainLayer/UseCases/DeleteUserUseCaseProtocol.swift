//
//  DeleteUserUseCaseProtocol.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 23/1/25.
//


protocol DeleteUserUseCaseProtocol {
    func execute(_ user: User, users: [User]) async throws -> [User]
}

enum DeleteUserUseCaseError: Error {
    case `internal`
}

class MockDeleteUserUseCase: DeleteUserUseCaseProtocol {
    var errorStub: DeleteUserUseCaseError!

    init() {
    }

    func execute(_ user: User, users: [User]) async throws -> [User] {
        if let errorStub {
            throw errorStub
        } else {
            var result = users
            result.removeAll { $0.id == user.id}
            return result
        }
    }
}
