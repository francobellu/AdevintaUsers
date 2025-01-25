import SwiftUI

struct ToolbarView: View {
    let usersCount: Int
    let isTyping: Bool
    @Binding var isAllSearch: Bool
    
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
        }
    }
}

#Preview("Typing") {
    ToolbarView(usersCount: 10, isTyping: true, isAllSearch: .constant(false))
}

#Preview("Not Typing") {
    ToolbarView(usersCount: 10, isTyping: false, isAllSearch: .constant(true))
}
