//
//  MockDeleteUserUseCase.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 26/1/25.
//


class MockDeleteUserUseCase: DeleteUserUseCaseProtocol {
    var errorStub: DeleteUserUseCaseError!

    func execute(_ user: User, users: [User]) -> [User] {
            var result = users
            result.removeAll { $0.id == user.id}
            return result
    }
}
