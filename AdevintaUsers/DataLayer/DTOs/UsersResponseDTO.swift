//
//  RandomUserResponse.swift
//  RandomUser
//
//  Created by Franco Bellu on 22/1/25.
//


import Foundation

struct UsersResponseDTO: Codable {
    let results: [UserDTO]
    let info: InfoDTO
}

extension UsersResponseDTO {
    func toUsers() -> [User] {
        results.map{$0.toDomain()}
    }
}
