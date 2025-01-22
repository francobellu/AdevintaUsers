import SwiftUI

struct UserDetailView: View {
    let user: User
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(radius: 10)

                VStack(spacing: 10) {
                    Text("\(user.name)")
                        .font(.title)
                        .fontWeight(.bold)

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

#Preview {
    let user = usersMocks().first!
    UserDetailView(user: user)
}
