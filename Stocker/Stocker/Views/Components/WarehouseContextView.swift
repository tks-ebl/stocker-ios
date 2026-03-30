import SwiftUI

struct WarehouseContextView: View {
    let warehouseName: String
    let userName: String
    let userCode: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(warehouseName)
                .font(.headline)
                .foregroundColor(.primary)

            HStack(spacing: 12) {
                Label(userName, systemImage: "person.fill")
                Label(userCode, systemImage: "building.2.fill")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(14)
    }
}
