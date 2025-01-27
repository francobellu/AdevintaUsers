//
//  UsersEndpoint.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 27/1/25.
//


import Foundation

enum UsersEndpoint: EndpointProtocol {
    case getUsers(batchSize: Int)

    var method: String {
        switch self {
        case .getUsers:
            return "GET"
        }
    }

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
