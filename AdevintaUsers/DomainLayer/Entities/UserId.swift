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

extension UserId: Identifiable, Equatable, Hashable {
    var id: Int {
        (name + value).hashValue
    }
}
