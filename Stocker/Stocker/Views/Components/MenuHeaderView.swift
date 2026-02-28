import SwiftUI

struct MenuHeaderView: View {
    @EnvironmentObject var menuState: MenuState

    var title: String

    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    menuState.isMenuOpen.toggle()
                }
            }) {
                Image(systemName: "line.horizontal.3")
                    .font(.title2)
                    .foregroundColor(.primary)
            }

            Text(title)
                .font(.title2.bold())
                .padding(.leading, 8)

            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
    }
}
