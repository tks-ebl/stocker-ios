import SwiftUI

struct MainContentView: View {
    @EnvironmentObject var menuState: MenuState
    @EnvironmentObject var userSession: UserSession
    @StateObject private var dashboardViewModel = DashboardViewModel()

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

    private var dashboardShippingResultCount: Int {
        dashboardViewModel.summary?.shippingResultCountToday ?? todayShippingResults.count
    }

    private var totalInventoryQuantity: Int {
        inventoryItems.reduce(0) { $0 + $1.quantity }
    }

    private var dashboardInventoryCount: Int {
        dashboardViewModel.summary?.inventoryItemCount ?? totalInventoryQuantity
    }

    private var todayShippingQuantity: Int {
        todayShippingResults.reduce(0) { $0 + $1.quantity }
    }

    private var dashboardShippingPlanCount: Int {
        dashboardViewModel.summary?.shippingPlanCount ?? (pendingShippingItemsCount + discrepancyCount)
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

            if let errorMessage = dashboardViewModel.errorMessage, userSession.usesWebAPI {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            VStack(spacing: 16) {
                if dashboardViewModel.isLoading && userSession.usesWebAPI {
                    ProgressView("Web API から集計を取得しています")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                InfoCardView(title: "本日の出荷実績", value: dashboardShippingResultCount, color: .blue, subtitle: userSession.usesWebAPI ? "Web API の今日の実績件数" : "今日の処理件数")
                InfoCardView(title: "本日の出荷数量", value: todayShippingQuantity, color: .green, subtitle: "今日の出荷個数")
                InfoCardView(title: "在庫総数", value: dashboardInventoryCount, color: .purple, subtitle: userSession.usesWebAPI ? "Web API の在庫件数" : "倉庫内の在庫個数")
                InfoCardView(title: userSession.usesWebAPI ? "本日の出荷予定" : "未処理件数", value: dashboardShippingPlanCount, color: .indigo, subtitle: userSession.usesWebAPI ? "Web API の当日出荷予定件数" : "未入力 + 差分あり")
                
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
        .task(id: "\(userSession.currentWarehouse?.apiWarehouseId ?? "")-\(userSession.dataRefreshKey)") {
            await dashboardViewModel.loadIfNeeded(userSession: userSession)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月d日"
        return formatter.string(from: date)
    }
}
