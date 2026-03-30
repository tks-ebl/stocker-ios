import SwiftUI

struct MainContentView: View {
    @EnvironmentObject var menuState: MenuState
    @EnvironmentObject var userSession: UserSession

    // 仮の日付データ
    let lastInventoryDate = Date(timeIntervalSinceNow: -86400 * 30) // 30日前
    let nextInventoryDate = Date(timeIntervalSinceNow: 86400 * 60)  // 60日後

    private var warehouseId: String {
        userSession.currentWarehouse?.id ?? ""
    }

    private var currentWarehouseName: String {
        userSession.currentWarehouse?.name ?? "未選択"
    }

    private var shippingPlans: [ShippingPlan] {
        sampleShippingPlans.filter { $0.warehouseId == warehouseId }
    }

    private var shippingResults: [ShippingResult] {
        sampleShippingResults.filter { $0.warehouseId == warehouseId }
    }

    private var inventoryItems: [InventoryItem] {
        sampleInventoryItems.filter { $0.warehouseId == warehouseId }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // ヘッダー（≡ ボタンあり）
            MenuHeaderView(title: "STOCKER")

            Text("本日の状況")
                .font(.title.bold())
                .padding(.horizontal)

            Text(currentWarehouseName)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            VStack(spacing: 16) {
                InfoCardView(title: "出荷予定", value: shippingPlans.count, color: .blue)
                InfoCardView(title: "出荷実績", value: shippingResults.count, color: .green)
                InfoCardView(title: "在庫品目", value: inventoryItems.count, color: .purple)
                InfoCardView(title: "差分あり", value: shippingPlans.flatMap { $0.items ?? [] }.filter { $0.actual != nil && $0.actual != $0.quantity }.count, color: .indigo)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("棚卸日")
                        .font(.headline)
                        .foregroundColor(.gray)

                    HStack {
                        Spacer()
                        Text("前回: \(formattedDate(lastInventoryDate))")
                            .font(.body)
                    }

                    HStack {
                        Spacer()
                        Text("次回: \(formattedDate(nextInventoryDate))")
                            .font(.body)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 1)

            }
            .padding(.horizontal)

            Spacer()
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月d日"
        return formatter.string(from: date)
    }
}
