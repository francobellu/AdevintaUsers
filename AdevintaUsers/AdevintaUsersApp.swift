//
//  AdevintaUsersApp.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 22/1/25.
//

import SwiftUI

@main
struct AdevintaUsersApp: App {

    // TODO: use DIContainer
    let fetchUsersUseCase: MockFetchUsersUseCase = {
        let fetchUsersUseCase = MockFetchUsersUseCase() // TODO: use real one when implemented
        fetchUsersUseCase.usersResultFactory = { .success(User.randomMocks(num: 8)) }
        return fetchUsersUseCase
    }()

    let deleteUserUseCase: DeleteUserUseCase = {
        let deleteUserUseCase = DeleteUserUseCase()
        return deleteUserUseCase
    }()

    let removeDuplicatedUsersUseCase: RemoveDuplicatedUsersUseCase = {
        let removeDuplicatedUsersUseCase = RemoveDuplicatedUsersUseCase()
        return removeDuplicatedUsersUseCase
    }()

    var body: some Scene {
        WindowGroup {
            let viewModel = UserListScreenModel(
                fetchUsersUseCase: fetchUsersUseCase,
                deleteUserUseCase: deleteUserUseCase,
                removeDuplicatedUsersUseCase: removeDuplicatedUsersUseCase
            )
            UserListScreen(viewModel: viewModel)
        }
    }
}
