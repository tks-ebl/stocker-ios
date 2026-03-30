import SwiftUI

struct MainContentView: View {
    @EnvironmentObject var menuState: MenuState
    @EnvironmentObject var userSession: UserSession

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

    private var todayShippingResults: [ShippingResult] {
        shippingResults.filter { Calendar.current.isDateInToday($0.date) }
    }

    private var totalInventoryQuantity: Int {
        inventoryItems.reduce(0) { $0 + $1.quantity }
    }

    private var todayShippingQuantity: Int {
        todayShippingResults.reduce(0) { $0 + $1.quantity }
    }

    private var pendingShippingItemsCount: Int {
        shippingPlans.flatMap { $0.items ?? [] }.filter { $0.actual == nil }.count
    }

    private var discrepancyCount: Int {
        shippingPlans
            .flatMap { $0.items ?? [] }
            .filter { $0.actual != nil && $0.actual != $0.quantity }
            .count
    }

    private var lastInventoryDate: Date {
        inventoryItems
            .flatMap(\.history)
            .map(\.movementDate)
            .max() ?? Date()
    }

    private var nextInventoryDate: Date {
        Calendar.current.date(byAdding: .day, value: 30, to: lastInventoryDate) ?? lastInventoryDate
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
                InfoCardView(title: "本日の出荷実績", value: todayShippingResults.count, color: .blue, subtitle: "今日の処理件数")
                InfoCardView(title: "本日の出荷数量", value: todayShippingQuantity, color: .green, subtitle: "今日の出荷個数")
                InfoCardView(title: "在庫総数", value: totalInventoryQuantity, color: .purple, subtitle: "倉庫内の在庫個数")
                InfoCardView(title: "未処理件数", value: pendingShippingItemsCount + discrepancyCount, color: .indigo, subtitle: "未入力 + 差分あり")
                
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
