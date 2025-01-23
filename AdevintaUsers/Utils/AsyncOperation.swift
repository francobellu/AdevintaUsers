//
//  AsyncOperation.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 23/1/25.
//

enum AsyncOperation<T> {
    case success(result: T? = nil)
    case failed(_ error: any Error)
    case inProgress
}

extension AsyncOperation: Equatable {
    public static func == (lhs: AsyncOperation<T>, rhs: AsyncOperation<T>) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success): return true
        case (.failed, .failed): return true
        case (.inProgress, .inProgress): return true
        default: return false
        }
    }
}
