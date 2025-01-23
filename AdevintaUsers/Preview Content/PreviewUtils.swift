//
//  TestUtils.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 23/1/25.
//


import SwiftUI

func usersMocks(num: Int) -> [User] {
    var result: [User] = []
    for _ in 0..<num {
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
        let pictures = [
            "https://randomuser.me/api/portraits/men/1.jpg",
            "https://randomuser.me/api/portraits/women/1.jpg",
            "https://randomuser.me/api/portraits/men/2.jpg",
            "https://randomuser.me/api/portraits/women/2.jpg"
        ]

        let firstName = firstNames.randomElement() ?? "User"
        let lastName = lastNames.randomElement() ?? "Test"

        let user = User(
            id: UserId(
                name: "\(firstName)\(lastName)",
                value: UUID().uuidString
            ),
            name: Name(
                first: firstName,
                last: lastName
            ),
            email: "\(firstName.lowercased()).\(lastName.lowercased())@example.com",
            phone: phones.randomElement() ?? "+0000000000",
            picture: Picture(
                large: pictures.randomElement() ?? ""
            )
        )
        return user
    }
}
