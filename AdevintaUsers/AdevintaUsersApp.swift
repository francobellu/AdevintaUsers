//
//  AdevintaUsersApp.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 22/1/25.
//

import SwiftUI

@main
struct AdevintaUsersApp: App {

    // TODO: 1 use DIContainer
    var body: some Scene {
        WindowGroup {
            let users = usersMocks(num: 50)
            let viewModel = UserListViewModel(users: users)
            UserListView(viewModel: viewModel)
        }
    }
}
