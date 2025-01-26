//
//  UserIdEntity.swift
//  RandomUser
//
//  Created by Franco Bellu on 22/1/25.
//

import Foundation

struct UserId{
    let name: String
    let value: String
}

extension UserId: Identifiable, Hashable {
    var id: String {
        name + "::" + value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(value)
    }
}
