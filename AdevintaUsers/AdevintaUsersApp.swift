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

    // TODO: use real use cases
    let fetchUsersUseCase: MockFetchUsersUseCase = {
        let fetchUsersUseCase = MockFetchUsersUseCase()
        fetchUsersUseCase.usersResultFactory = { .success(User.randomMocks(num: 8)) }
        return fetchUsersUseCase
    }()

    let deleteUserUseCase: DeleteUserUseCase = {
        let deleteUserUseCase = DeleteUserUseCase()
        return deleteUserUseCase
    }()

    var body: some Scene {
        WindowGroup {
            let viewModel = UserListScreenModel(
                fetchUsersUseCase: fetchUsersUseCase,
                deleteUserUseCase: deleteUserUseCase
            )
            UserListScreen(viewModel: viewModel)
        }
    }
}
