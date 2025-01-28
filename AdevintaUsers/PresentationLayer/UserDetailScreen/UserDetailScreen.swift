import SwiftUI

struct UserDetailScreen: View {
    let user: User
    var body: some View {
        if let url = URL(string: user.picture.large) {
            ScrollView {
                VStack(spacing: 20) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(radius: 10)

                    VStack(spacing: 10) {
                        Text("\(user.name.first) \(user.name.last)")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("ID: \(user.userId.value) ")
                            .font(.caption)

                        Link(user.email, destination: URL(string: "mailto:\(user.email)")!)
                            .font(.headline)
                            .foregroundColor(.blue)

                        Link(user.phone, destination: URL(string: "tel:\(user.phone)")!)
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    let user = User.randomMock()
    UserDetailScreen(user: user)
}
