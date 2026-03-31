import Foundation

@MainActor
final class InventoryViewModel: ObservableObject {
    @Published private(set) var items: [InventoryItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    func loadIfNeeded(userSession: UserSession) async {
        guard userSession.usesWebAPI else {
            items = []
            errorMessage = nil
            isLoading = false
            return
        }

        guard let apiWarehouseId = userSession.currentWarehouse?.apiWarehouseId,
              let scopeWarehouseId = userSession.currentWarehouse?.id,
              let token = TokenManager.load() else {
            items = []
            errorMessage = "Web API の認証情報が見つかりません。"
            isLoading = false
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            items = try await StockerAPIService.shared.fetchInventory(
                warehouseId: apiWarehouseId,
                scopeWarehouseId: scopeWarehouseId,
                bearerToken: token
            )
        } catch {
            errorMessage = error.localizedDescription
            items = []
        }

        isLoading = false
    }
}
