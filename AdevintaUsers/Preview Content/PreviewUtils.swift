//
//  TestUtils.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 23/1/25.
//


import SwiftUI

func usersMocks() -> [User] {
    var result: [User] = []
    for _ in 0..<50 {
        let user = User.randomMock()
        result.append(user)
    }
    return result
}

extension User {
    static func randomMock() -> User {
        let firstNames = ["John", "Jane", "Mike", "Sarah", "David", "Emma", "Tom", "Lucy"]
        let lastNames = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis"]
        let phones = ["+1234567890", "+1987654321", "+1472583690", "+1589632470"]

        let firstName = firstNames.randomElement() ?? "User"
        let lastName = lastNames.randomElement() ?? "Test"

        let user = User(
            id: UUID(),
            name: firstName,
            email: "\(firstName.lowercased()).\(lastName.lowercased())@example.com",
            phone: phones.randomElement() ?? "+0000000000"
        )

        return user
    }
}
