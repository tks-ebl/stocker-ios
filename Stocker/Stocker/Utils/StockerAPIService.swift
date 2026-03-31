import Foundation

struct APILoginRequest: Encodable {
    let userCode: String
    let password: String
}

struct APILoginResponse: Decodable {
    let accessToken: String
    let expiresAt: Date
    let user: APIUserSummary
    let warehouse: APIWarehouseSummary
}

struct APIUserSummary: Decodable {
    let userId: UUID
    let userCode: String
    let userName: String
}

struct APIWarehouseSummary: Decodable {
    let warehouseId: UUID
    let warehouseCode: String
    let warehouseName: String
}

struct APIDashboardResponse: Decodable {
    let warehouseId: UUID
    let shippingPlanCount: Int
    let shippingResultCountToday: Int
    let inventoryItemCount: Int
}

struct APIInventoryItemResponse: Decodable {
    let itemId: UUID
    let itemCode: String
    let itemName: String
    let locationCode: String
    let quantity: Int
}

struct APIInventoryHistoryResponse: Decodable {
    let historyId: UUID
    let itemId: UUID
    let movementDateTime: Date
    let quantityDelta: Int
    let reason: String
    let executedByUserCode: String
}

final class StockerAPIService {
    static let shared = StockerAPIService()

    private let client: APIClient

    init(client: APIClient = .shared) {
        self.client = client
    }

    func checkHealth() async throws {
        try await client.checkHealth()
    }

    func login(userCode: String, password: String) async throws -> APILoginResponse {
        try await client.post(
            path: "/auth/login",
            body: APILoginRequest(userCode: userCode, password: password)
        )
    }

    func fetchDashboard(warehouseId: String, bearerToken: String) async throws -> DashboardSummary {
        let response: APIDashboardResponse = try await client.get(
            path: "/warehouses/\(warehouseId)/dashboard",
            bearerToken: bearerToken
        )

        return DashboardSummary(
            shippingPlanCount: response.shippingPlanCount,
            shippingResultCountToday: response.shippingResultCountToday,
            inventoryItemCount: response.inventoryItemCount
        )
    }

    func fetchInventory(warehouseId: String, scopeWarehouseId: String, bearerToken: String) async throws -> [InventoryItem] {
        let response: [APIInventoryItemResponse] = try await client.get(
            path: "/warehouses/\(warehouseId)/inventory",
            bearerToken: bearerToken
        )

        return response.map { item in
            InventoryItem(
                id: item.itemId,
                warehouseId: scopeWarehouseId,
                location: item.locationCode,
                itemCode: item.itemCode,
                itemName: item.itemName,
                quantity: item.quantity,
                history: []
            )
        }
    }

    func fetchInventoryHistory(warehouseId: String, itemId: String, bearerToken: String) async throws -> [InventoryHistory] {
        let response: [APIInventoryHistoryResponse] = try await client.get(
            path: "/warehouses/\(warehouseId)/inventory/\(itemId)/history",
            bearerToken: bearerToken
        )

        return response.map { history in
            InventoryHistory(
                id: history.historyId,
                movementDate: history.movementDateTime,
                quantity: history.quantityDelta,
                executedBy: history.executedByUserCode,
                reason: history.reason
            )
        }
    }
}
