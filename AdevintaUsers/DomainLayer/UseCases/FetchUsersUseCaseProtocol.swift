//
//  FetchUsersUseCaseProtocol.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 23/1/25.
//


import Foundation

protocol FetchUsersUseCaseProtocol {
    func execute(page: Int, count: Int) async throws -> [User]
}

class MockFetchUsersUseCase: FetchUsersUseCaseProtocol {
    var usersResultStub: Result <[User], UserListViewModelError>!
    var isLongOperation: Bool

    init(isLongOperation: Bool = false) {
        self.isLongOperation = isLongOperation
    }

    func execute(page: Int, count: Int) async throws -> [User] {
        if isLongOperation {
            try await Task.sleep(for: .seconds(100))
        }
        return try usersResultStub.get()
    }
}

