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

    // TODO: use real fetchUsersUseCase
    let fetchUsersUseCase: MockFetchUsersUseCase = {
        let fetchUsersUseCase = MockFetchUsersUseCase()
        fetchUsersUseCase.usersResultStub = .success(User.randomMocks(num: 20))
        return fetchUsersUseCase
    }()

    var body: some Scene {
        WindowGroup {
            let viewModel = UserListViewModel(fetchUsersUseCase: fetchUsersUseCase)
            UserListView(viewModel: viewModel)
        }
    }
}
