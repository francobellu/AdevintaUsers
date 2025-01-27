//
//  RemoveDuplicatedUsersUseCaseProtocol.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 26/1/25.
//

import Foundation

protocol RemoveDuplicatedUsersUseCaseProtocol {
    func execute(users: [User]) -> (unique: [User], duplicates: [User]) 
}
