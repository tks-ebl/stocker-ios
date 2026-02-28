import SwiftUI

struct InfoCardView: View {
    let title: String
    let value: Int
    let color: Color
    var subtitle: String? = nil

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            Text("\(value) 件")
                .font(.largeTitle.bold())
                .foregroundColor(color)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.1))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
