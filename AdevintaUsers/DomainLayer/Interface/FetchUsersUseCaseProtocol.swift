//
//  FetchUsersUseCaseProtocol.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 23/1/25.
//


import Foundation

protocol FetchUsersUseCaseProtocol {
    func execute(batchSize: Int) async throws -> [User]
}



