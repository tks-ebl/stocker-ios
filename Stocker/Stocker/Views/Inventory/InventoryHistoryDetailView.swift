import SwiftUI

struct InventoryHistoryDetailView: View {
    let item: InventoryItem

    var body: some View {
        VStack {
            List {
                Section(header: Text("商品情報")) {
                    Text("商品名: \(item.itemName)")
                    Text("ロケ: \(item.location)")
                    Text("コード: \(item.itemCode)")
                    Text("在庫数: \(item.quantity)")
                }
                
                Section(header: Text("履歴")) {
                    ForEach(item.history) { h in
                        VStack(alignment: .leading) {
                            Text("数量: \(h.quantity)")
                            Text("日時: \(formatted(date: h.movementDate))")
                            Text("ユーザー: \(h.executedBy)")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                }
            }
        }
        .navigationTitle("📦 入出庫履歴")
    }

    private func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }
}
