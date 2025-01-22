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
        HStack {
            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)

                .frame(width: 50, height: 50)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text("\(user.name) ")
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

#Preview {
    let user = usersMocks().first!
    UserRowView(user: user)
}
