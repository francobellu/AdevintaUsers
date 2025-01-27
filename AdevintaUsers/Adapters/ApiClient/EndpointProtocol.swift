//
//  EndpointProtocol.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 27/1/25.
//


import Foundation

protocol EndpointProtocol: Hashable {
    var method: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}
