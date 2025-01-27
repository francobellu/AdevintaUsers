import SwiftUI

struct ModalView: View {
    let title: String
    let users: [User]
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            List(users) { user in
                UserRowView(user: user)
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    ModalView(
        title: "Duplicates",
        users: User.randomMocks(num: 3),
        isPresented: .constant(true)
    )
}

