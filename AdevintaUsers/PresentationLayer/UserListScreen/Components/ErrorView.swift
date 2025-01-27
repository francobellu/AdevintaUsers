import SwiftUI

struct ErrorView: View {
    let userMessage: String
    let retryButtonStr: String
    var onRetry: () -> Void

    init(userMessage: String, retryButtonStr: String = "Retry", onRetry: @escaping () -> Void) {
        self.userMessage = userMessage
        self.retryButtonStr = retryButtonStr
        self.onRetry = onRetry
    }
    
    var body: some View {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.red)
                
                Text(userMessage)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                Button(action: onRetry) {
                    Text(retryButtonStr)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 120, height: 40)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemBackground))
    }
}

#Preview("loadingFailure") {
    let error = UserListScreenModelError.loadingFailure.userMessage
    ErrorView(userMessage: error) {
        // Preview retry action
        print("Retry tapped")
    }
}

#Preview("deletionFailed") {
    let error = UserListScreenModelError.deletionFailed.userMessage
    ErrorView(userMessage: error) {
        // Preview retry action
        print("Retry tapped")
    }
}
