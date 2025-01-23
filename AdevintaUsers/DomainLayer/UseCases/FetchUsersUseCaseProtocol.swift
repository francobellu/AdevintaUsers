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

    init() {
    }

    func execute(page: Int, count: Int) async throws -> [User] {
        try usersResultStub.get()
    }
}

