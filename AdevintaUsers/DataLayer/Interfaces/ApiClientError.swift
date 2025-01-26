//
//  ApiClientError.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 27/1/25.
//


import Foundation

public enum ApiClientError: Error {
    case networkError
}

extension ApiClientError: Equatable {
    public static func == (lhs: ApiClientError, rhs: ApiClientError) -> Bool {
        switch (lhs, rhs) {
        case (.networkError, .networkError):
            return true
        }
    }
}
