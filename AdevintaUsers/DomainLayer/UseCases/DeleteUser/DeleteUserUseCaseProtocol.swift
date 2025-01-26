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

