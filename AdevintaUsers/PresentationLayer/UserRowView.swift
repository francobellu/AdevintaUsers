//
//  UserRowView.swift
//  AdevistaUsers
//
//  Created by Franco Bellu on 22/1/25.
//

import SwiftUI

struct UserRowView: View {
    let user: User
    
    var body: some View {
        if let url = URL(string: user.picture.large) {
            HStack {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text("\(user.name.first) \(user.name.last)")
                        .font(.headline)
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(user.phone)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    let user = User.randomMock()
    UserRowView(user: user)

}
