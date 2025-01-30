import SwiftUI

struct LoginInformationSection: View {
    let user: User
    let vSpacing: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: vSpacing) {
            Text("Login Information")
                .font(.title)
            if !user.login.uuid.isEmpty {
                ContactRow(label: "UUID", value: user.login.uuid, icon: "key")
            }
            if !user.login.salt.isEmpty {
                ContactRow(label: "Salt", value: user.login.salt, icon: "lock.shield")
            }
            if !user.login.md5.isEmpty {
                ContactRow(label: "MD5", value: user.login.md5, icon: "lock.shield")
            }
            if !user.login.sha1.isEmpty {
                ContactRow(label: "SHA1", value: user.login.sha1, icon: "lock.shield")
            }
            if !user.login.sha256.isEmpty {
                ContactRow(label: "SHA256", value: user.login.sha256, icon: "lock.shield")
            }
            if !user.login.password.isEmpty {
                ContactRow(label: "Password", value: String(repeating: "*", count: user.login.password.count), icon: "eye.slash")
            }
        }
    }
}
