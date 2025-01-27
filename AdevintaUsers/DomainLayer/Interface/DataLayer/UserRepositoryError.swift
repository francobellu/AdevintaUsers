//
//  UserRepositoryError.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 26/1/25.
//

import Foundation

enum UserRepositoryError: Error, Equatable {
    case networking(Error)

    static func == (lhs: UserRepositoryError, rhs: UserRepositoryError) -> Bool {
        switch (lhs, rhs) {
        case (.networking(let lhsError), .networking(let rhsError)):
            let lhsErr = (lhsError as NSError)
            let rhsErr = (rhsError as NSError)
            return lhsErr == rhsErr
        }
    }
}
