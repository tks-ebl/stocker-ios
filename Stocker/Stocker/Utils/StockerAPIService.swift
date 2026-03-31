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

struct APIShippingPlanResponse: Decodable {
    let shippingPlanId: UUID
    let shippingDate: String
    let destinationCode: String
    let destinationName: String
    let items: [APIShippingPlanItemResponse]
}

struct APIShippingPlanItemResponse: Decodable {
    let shippingPlanItemId: UUID
    let itemCode: String
    let itemName: String
    let locationCode: String
    let plannedQuantity: Int
    let actualQuantity: Int
}

struct APIShippingResultResponse: Decodable {
    let shippingResultId: UUID
    let shippingPlanId: UUID?
    let itemCode: String
    let itemName: String
    let locationCode: String
    let destinationCode: String
    let quantity: Int
    let executedByUserCode: String
    let executedAt: Date
}

struct APICreateShippingResultsRequest: Encodable {
    let shippingPlanId: UUID?
    let destinationCode: String
    let executedAt: Date?
    let results: [APICreateShippingResultItemRequest]
}

struct APICreateShippingResultItemRequest: Encodable {
    let itemCode: String
    let itemName: String
    let locationCode: String
    let quantity: Int
}

struct APICreateShippingResultsResponse: Decodable {
    let warehouseId: UUID
    let createdCount: Int
    let executedAt: Date
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

    func fetchShippingPlans(
        warehouseId: String,
        scopeWarehouseId: String,
        selectedDate: Date,
        destinationCode: String,
        bearerToken: String
    ) async throws -> [ShippingPlan] {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"

        var queryItems = [
            URLQueryItem(name: "shippingDate", value: formatter.string(from: selectedDate))
        ]

        if !destinationCode.isEmpty {
            queryItems.append(URLQueryItem(name: "destinationCode", value: destinationCode))
        }

        let response: [APIShippingPlanResponse] = try await client.get(
            path: "/warehouses/\(warehouseId)/shipping-plans",
            queryItems: queryItems,
            bearerToken: bearerToken
        )

        return response.map { plan in
            ShippingPlan(
                id: plan.shippingPlanId.uuidString,
                warehouseId: scopeWarehouseId,
                destinationCode: plan.destinationCode,
                destinationName: plan.destinationName,
                itemCount: plan.items.count,
                items: plan.items.map { item in
                    ShippingItem(
                        id: item.shippingPlanItemId.uuidString,
                        location: item.locationCode,
                        code: item.itemCode,
                        name: item.itemName,
                        quantity: item.plannedQuantity,
                        actual: item.actualQuantity == 0 ? nil : item.actualQuantity
                    )
                }
            )
        }
    }

    func fetchShippingResults(
        warehouseId: String,
        scopeWarehouseId: String,
        date: Date,
        userCode: String,
        bearerToken: String
    ) async throws -> [ShippingResult] {
        let calendar = Calendar(identifier: .gregorian)
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
        let formatter = ISO8601DateFormatter()

        var queryItems = [
            URLQueryItem(name: "dateFrom", value: formatter.string(from: startOfDay)),
            URLQueryItem(name: "dateTo", value: formatter.string(from: endOfDay))
        ]

        if !userCode.isEmpty {
            queryItems.append(URLQueryItem(name: "userCode", value: userCode))
        }

        let response: [APIShippingResultResponse] = try await client.get(
            path: "/warehouses/\(warehouseId)/shipping-results",
            queryItems: queryItems,
            bearerToken: bearerToken
        )

        return response.map { result in
            ShippingResult(
                id: result.shippingResultId,
                warehouseId: scopeWarehouseId,
                itemName: result.itemName,
                quantity: result.quantity,
                date: result.executedAt,
                userCode: result.executedByUserCode
            )
        }
    }

    func createShippingResults(
        warehouseId: String,
        shippingPlanId: String?,
        destinationCode: String,
        items: [ShippingItem],
        bearerToken: String
    ) async throws -> Int {
        let request = APICreateShippingResultsRequest(
            shippingPlanId: shippingPlanId.flatMap(UUID.init(uuidString:)),
            destinationCode: destinationCode,
            executedAt: Date(),
            results: items.compactMap { item in
                guard let actual = item.actual, actual > 0 else {
                    return nil
                }

                return APICreateShippingResultItemRequest(
                    itemCode: item.code,
                    itemName: item.name,
                    locationCode: item.location,
                    quantity: actual
                )
            }
        )

        let response: APICreateShippingResultsResponse = try await client.post(
            path: "/warehouses/\(warehouseId)/shipping-results",
            body: request,
            bearerToken: bearerToken
        )

        return response.createdCount
    }
}
