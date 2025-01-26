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

    func fetchUsers(batchSize: Int, page: Int) async throws -> [User] {
        let usersDTO: [UserDTO] = try await apiClient.sendRequest(endpoint: UsersEndpoint.getUsers , method: .get)
        return usersDTO.map{ $0.toDomain() }
    }
}

extension UserRepository {
    public func getUsers() async throws -> [User] {
        let endpoint = UsersEndpoint.getUsers
        let usersResponseDTO: UsersResponseDTO = try await apiClient.sendRequest(
            endpoint: endpoint,
            method: HTTPMethod.get
        )
        let users = extractUsersFromResponseDTO(usersResponseDTO)
        return users
    }

    private func extractUsersFromResponseDTO(_ usersResponseDTO: UsersResponseDTO) -> [User] {
        let usersDTO: [UserDTO] = usersResponseDTO.results
        let users = usersDTO.map{$0.toDomain()}
        return users
    }
}


enum UsersEndpoint: EndpointProtocol {
    case getUsers
    var path: String {
        switch self {
        case .getUsers:
            return "/"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .getUsers:
            return [URLQueryItem(name: "results", value: "10")]
        }
    }
}

protocol EndpointProtocol: Hashable {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
}
