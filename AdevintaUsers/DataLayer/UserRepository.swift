//
//  UserRepository.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 26/1/25.
//

import Foundation

class UserRepository: UserRepositoryProtocol {
    let apiClient: ApiClientProtocol

    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchUsers(batchSize: Int) async throws -> [User] {
        let endpoint = UsersEndpoint.getUsers
        let usersResponseDTO: UsersResponseDTO = try await apiClient.sendRequest(
            endpoint: endpoint(batchSize)
        )
        let users = extractUsersFromResponseDTO(usersResponseDTO)
        return users
    }
}

extension UserRepository {
    private func extractUsersFromResponseDTO(_ usersResponseDTO: UsersResponseDTO) -> [User] {
        let usersDTO: [UserDTO] = usersResponseDTO.results
        let users = usersDTO.map{$0.toDomain()}
        return users
    }
}






