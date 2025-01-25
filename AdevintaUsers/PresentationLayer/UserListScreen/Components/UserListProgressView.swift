import SwiftUI

struct UserListProgressView: View {
    var body: some View {
        ProgressView()
            .frame(idealWidth: .infinity, alignment: .center)
    }
}

#Preview {
    UserListProgressView()
}
