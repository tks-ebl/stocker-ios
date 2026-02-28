import SwiftUI

struct MenuItemView: View {
    let title: String
    let systemImage: String
    var isSelected: Bool = false  // ← ハイライト表示用（任意）
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: systemImage)
                    .font(.system(size: 20))
                    .frame(width: 28, height: 28)
                    .foregroundColor(isSelected ? .white : .appPrimary)

                Text(title)
                    .font(.body)
                    .foregroundColor(isSelected ? .white : .primary)

                Spacer()
            }
            .padding()
            .background(isSelected ? Color.appPrimary : Color.clear)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
