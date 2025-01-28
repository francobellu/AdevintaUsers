//
//  MockUserDefaultsAdapter.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 28/1/25.
//


@testable import AdevintaUsers
import Testing
import Foundation

class MockUserDefaultsAdapter: UserDefaultsAdapterProtocol, @unchecked Sendable {
    var getUsersMock: [UserDTO] = []
    var savedUsersMock: [UserDTO]!
    var lastUsedKey: UserDefaultsAdapter.Key?

    func save(_ users: [UserDTO], for key: UserDefaultsAdapter.Key) {
        savedUsersMock = users
        lastUsedKey = key
    }

    func getUsers(for key: UserDefaultsAdapter.Key) -> [UserDTO] {
        lastUsedKey = key
        return getUsersMock
    }
}