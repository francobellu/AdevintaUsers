import SwiftUI

struct UserListFailedView: View {
    let error: Error
    
    var body: some View {
        Text("Error: \(error.localizedDescription)")
    }
}

#Preview {
    UserListFailedView(error: UserListScreenModelError.loadingFailure)
}
