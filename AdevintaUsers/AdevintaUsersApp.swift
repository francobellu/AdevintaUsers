//
//  AdevintaUsersApp.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 22/1/25.
//

import SwiftUI

@main
struct AdevintaUsersApp: App {
    let diContainer = DIContainer()
    
    var body: some Scene {
        WindowGroup {
            let viewModel = diContainer.userListScreenModel
            UserListScreen(viewModel: viewModel)
        }
    }
}
