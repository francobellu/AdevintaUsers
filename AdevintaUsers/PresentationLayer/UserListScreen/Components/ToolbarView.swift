import SwiftUI

struct ToolbarView: View {
    let usersCount: Int
    let isTyping: Bool

    let duplicateUsers: [User]
    let blacklistedUsers: [User]


    @Binding var isAllSearch: Bool
    @Binding var showingDuplicates: Bool
    @Binding var showingBlacklist: Bool
    
    var body: some View {
        HStack {
            Spacer()
            Text("Users: \(usersCount)")
            Spacer()
            if isTyping {
                HStack(spacing: 4) {
                    Text(isAllSearch ? "Search ALL" : "Search ANY")
                    Toggle("", isOn: $isAllSearch)
                        .toggleStyle(.switch)
                        .tint(.green)
                        .labelsHidden()
                        .scaleEffect(0.75)
                        .frame(width: 40)
                }
            }
            Spacer()
            HStack(spacing: 16) {
                Button {
                    showingDuplicates.toggle()
                    showingBlacklist = false
                } label: {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(showingDuplicates ? .blue : .gray)
                }
                
                Button {
                    showingBlacklist.toggle()
                    showingDuplicates = false
                } label: {
                    Image(systemName: "xmark.bin")
                        .foregroundColor(showingBlacklist ? .blue : .gray)
                }
            }
        }
        .sheet(isPresented: $showingDuplicates) {
            ModalView(
                title: "Duplicate Users",
                users: duplicateUsers,
                isPresented: $showingDuplicates
            )
        }
        .sheet(isPresented: $showingBlacklist) {
            ModalView(
                title: "Blacklisted Users",
                users: blacklistedUsers,
                isPresented: $showingBlacklist
            )
        }
    }
}

#Preview("Typing") {
    ToolbarView(
        usersCount: 10,
        isTyping: true,
        duplicateUsers: User.randomMocks(num: 2),
        blacklistedUsers: User.randomMocks(num: 2),
        isAllSearch: .constant(false),
        showingDuplicates: .constant(false),
        showingBlacklist: .constant(false)
    )
}

#Preview("Not Typing") {
    ToolbarView(
        usersCount: 10,
        isTyping: false,
        duplicateUsers: User.randomMocks(num: 2),
        blacklistedUsers: User.randomMocks(num: 2),
        isAllSearch: .constant(true),
        showingDuplicates: .constant(false),
        showingBlacklist: .constant(false)
    )
}
