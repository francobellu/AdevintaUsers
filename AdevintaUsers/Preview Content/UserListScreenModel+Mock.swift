extension UserListScreenModel {
    static func previewMock(
        usersResult: Result<[User], UserListScreenModelError> = .success(User.randomMocks(num: 20)),
        isLongOperation: Bool = false
    ) -> UserListScreenModel {
        let mockFetchUsersUseCase = MockFetchUsersUseCase(isLongOperation: isLongOperation)
        mockFetchUsersUseCase.usersResultStub = usersResult

        let mockDeleteUserUseCase = MockDeleteUserUseCase()
        let mockGetDeleteUserUseCase = MockGetDeletedUserUseCase()
        let removeDuplicatedUsersUseCase = MockRemoveDuplicatedUsersUseCase()

        return UserListScreenModel(
            usersPerBatch: 7,
            fetchUsersUseCase: mockFetchUsersUseCase,
            deleteUserUseCase: mockDeleteUserUseCase, 
            getDeletedUserUseCase: mockGetDeleteUserUseCase,
            removeDuplicatedUsersUseCase: removeDuplicatedUsersUseCase
        )
    }
}
