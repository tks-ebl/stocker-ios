import SwiftUI

struct InventoryHistoryPreviewView: View {
    let item: InventoryItem
    var onDetail: (() -> Void)?  // 詳細ボタン押下で発火

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("📜 履歴プレビュー")
                    .font(.title3.bold())
                Spacer()
                Button(action: {
                    onDetail?()
                }) {
                    Image(systemName: "arrow.forward.circle.fill")
                        .font(.title2)
                        .foregroundColor(.accentColor)
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("商品: \(item.itemName)")
                    .font(.headline)
                Text("コード: \(item.itemCode)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("ロケ: \(item.location)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(item.history.prefix(3))) { h in
                    VStack(alignment: .leading) {
                        Text("📅 \(formatted(date: h.movementDate))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        HStack {
                            Text("数: \(h.quantity)")
                            Spacer()
                            Text("実行: \(h.executedBy)")
                        }
                        .font(.body)
                    }
                }
            }
        }
        .padding()
    }

    private func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }
}
