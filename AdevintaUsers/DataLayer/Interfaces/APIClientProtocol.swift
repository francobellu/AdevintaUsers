//
//  APIClientProtocol.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 26/1/25.
//
import Foundation

protocol ApiClientProtocol: Sendable {
    func sendRequest<T: Decodable>(endpoint: any EndpointProtocol) async throws -> T
}
