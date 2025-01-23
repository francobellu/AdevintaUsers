//
//  Name.swift
//  RandomUser
//
//  Created by Franco Bellu on 22/1/25.
//


struct Name {
    let first: String
    let last: String
}

extension Name: Identifiable, Hashable {
    var id: String { first + last }
}
