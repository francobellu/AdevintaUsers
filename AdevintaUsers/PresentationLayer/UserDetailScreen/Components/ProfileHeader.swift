//
//  ProfileHeader.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 30/1/25.
//


import SwiftUI

struct ProfileHeader: View {
    let user: User

    var body: some View {
        VStack(alignment: .center) {
            if let url = URL(string: user.picture.large) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                } placeholder: {
                    ProgressView()
                }
            }

            Text("\(user.name.title) \(user.name.first) \(user.name.last)")
                .font(.title)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileHeader(user: .randomMock())
}
