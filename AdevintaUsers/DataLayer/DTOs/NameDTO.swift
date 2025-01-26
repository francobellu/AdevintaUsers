//
//  NameDTO.swift
//  RandomUser
//
//  Created by Franco Bellu on 22/1/25.
//


import Foundation

struct NameDTO: Codable {
    let first: String
    let last: String

    init(from name: Name) {
        self.first = name.first
        self.last = name.last
    }

    func toDomain() -> Name {
       Name(first: first, last: last)
    }
}