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
}
