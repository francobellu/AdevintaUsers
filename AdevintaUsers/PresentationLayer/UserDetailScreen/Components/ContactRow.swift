import SwiftUI

struct ContactRow: View {
    let label: String?
    let value: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon).padding(.leading, 4)
                .foregroundColor(.blue)
            if let label, !label.isEmpty {
                Text("\(label): \(value)")
                   .font(.callout)
            } else{
                Text("\(value)")
            }
            Spacer()
        }
    }
}

#Preview {
    ContactRow(
        label: "Email",
        value: "example@example.com",
        icon: "envelope"
    )
}
