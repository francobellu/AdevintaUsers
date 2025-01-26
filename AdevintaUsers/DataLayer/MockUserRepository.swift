//
//  MockUserRepository.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 26/1/25.
//

import Foundation

class MockUserRepository: UserRepositoryProtocol {
    var userStubs: Result< [User], UserRepositoryError>!

    func fetchUsers(batchSize: Int, page: Int) async throws -> [User]{
        try userStubs.get()
    }

    func deleteUser(_ user: User) async throws {
        // TODO:
    }
}


