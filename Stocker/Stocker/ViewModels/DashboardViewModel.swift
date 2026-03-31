import Foundation

struct DashboardSummary {
    let shippingPlanCount: Int
    let shippingResultCountToday: Int
    let inventoryItemCount: Int
}

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published private(set) var summary: DashboardSummary?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    func loadIfNeeded(userSession: UserSession) async {
        guard userSession.usesWebAPI else {
            summary = nil
            errorMessage = nil
            isLoading = false
            return
        }

        guard let apiWarehouseId = userSession.currentWarehouse?.apiWarehouseId,
              let token = TokenManager.load() else {
            summary = nil
            errorMessage = "Web API の認証情報が見つかりません。"
            isLoading = false
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            summary = try await StockerAPIService.shared.fetchDashboard(
                warehouseId: apiWarehouseId,
                bearerToken: token
            )
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
