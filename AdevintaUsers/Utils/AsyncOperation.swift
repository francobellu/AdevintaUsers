enum AsyncOperation<T> {
    case failed(_ error: any Error)
    case inProgress
}

extension AsyncOperation: Equatable {
    public static func == (lhs: AsyncOperation<T>, rhs: AsyncOperation<T>) -> Bool {
        switch (lhs, rhs) {
        case (.failed, .failed): return true
        case (.inProgress, .inProgress): return true
        default: return false
        }
    }
}
