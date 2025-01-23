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
        fetchUsersUseCase.usersResultStub = .success(User.randomMocks(num: 20))
        return fetchUsersUseCase
    }()

    let deleteUserUseCase: MockDeleteUserUseCase = {
        let deleteUserUseCase = MockDeleteUserUseCase()
        return deleteUserUseCase
    }()

    var body: some Scene {
        WindowGroup {
            let viewModel = UserListViewModel(
                fetchUsersUseCase: fetchUsersUseCase,
                deleteUserUseCase: deleteUserUseCase
            )
            UserListView(viewModel: viewModel)
        }
    }
}
