import SwiftUI

struct UserListProgressView: View {
    var body: some View {
        ProgressView()
            .scaleEffect(1.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    UserListProgressView()
}
