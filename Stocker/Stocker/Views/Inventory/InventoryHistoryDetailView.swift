import SwiftUI

struct InventoryHistoryDetailView: View {
    @EnvironmentObject var userSession: UserSession
    let item: InventoryItem
    @State private var histories: [InventoryHistory] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    private var displayHistories: [InventoryHistory] {
        userSession.usesWebAPI ? histories : item.history
    }

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
                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    if isLoading {
                        ProgressView("履歴を取得しています")
                    } else if displayHistories.isEmpty {
                        Text("履歴はありません")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(displayHistories) { h in
                            VStack(alignment: .leading) {
                                Text("数量: \(h.quantity)")
                                Text("日時: \(formatted(date: h.movementDate))")
                                if let reason = h.reason, !reason.isEmpty {
                                    Text("理由: \(reason)")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }
                                Text("ユーザー: \(h.executedBy)")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("📦 入出庫履歴")
        .task(id: item.id) {
            await loadHistoryIfNeeded()
        }
    }

    private func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }

    @MainActor
    private func loadHistoryIfNeeded() async {
        guard userSession.usesWebAPI else {
            histories = item.history
            errorMessage = nil
            isLoading = false
            return
        }

        guard let apiWarehouseId = userSession.currentWarehouse?.apiWarehouseId,
              let token = TokenManager.load() else {
            histories = []
            errorMessage = "Web API の認証情報が見つかりません。"
            isLoading = false
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            histories = try await StockerAPIService.shared.fetchInventoryHistory(
                warehouseId: apiWarehouseId,
                itemId: item.id.uuidString,
                bearerToken: token
            )
        } catch {
            histories = []
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
