//
//  File.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 26/1/25.
//

extension UserListScreenModel {
    static func previewMock(
        usersResult: Result<[User], UserListScreenModelError> = .success(User.randomMocks(num: 20)),
        isLongOperation: Bool = false
    ) -> UserListScreenModel {
        let mockFetchUsersUseCase = MockFetchUsersUseCase(isLongOperation: isLongOperation)
        mockFetchUsersUseCase.usersResultStub = usersResult

        let mockDeleteUserUseCase = MockDeleteUserUseCase()
        let removeDuplicatedUsersUseCase = RemoveDuplicatedUsersUseCase()
        
        return UserListScreenModel(
            usersPerBatch: 7,
            fetchUsersUseCase: mockFetchUsersUseCase,
            deleteUserUseCase: mockDeleteUserUseCase,
            removeDuplicatedUsersUseCase: removeDuplicatedUsersUseCase
        )
    }
}
