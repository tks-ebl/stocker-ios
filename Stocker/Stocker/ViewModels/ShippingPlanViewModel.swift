import Foundation

@MainActor
final class ShippingPlanViewModel: ObservableObject {
    @Published private(set) var plans: [ShippingPlan] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    func loadIfNeeded(userSession: UserSession, selectedDate: Date, customerCode: String) async {
        guard userSession.usesWebAPI else {
            plans = []
            errorMessage = nil
            isLoading = false
            return
        }

        guard let apiWarehouseId = userSession.currentWarehouse?.apiWarehouseId,
              let scopeWarehouseId = userSession.currentWarehouse?.id,
              let token = TokenManager.load() else {
            plans = []
            errorMessage = "Web API の認証情報が見つかりません。"
            isLoading = false
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            plans = try await StockerAPIService.shared.fetchShippingPlans(
                warehouseId: apiWarehouseId,
                scopeWarehouseId: scopeWarehouseId,
                selectedDate: selectedDate,
                destinationCode: customerCode,
                bearerToken: token
            )
        } catch {
            plans = []
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
