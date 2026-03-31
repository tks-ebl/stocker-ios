import Foundation

struct Warehouse: Identifiable, Equatable {
    let id: String
    let code: String
    let name: String
    let apiWarehouseId: String?

    static func scopeId(for warehouseCode: String) -> String {
        let normalizedCode = warehouseCode.uppercased()

        if normalizedCode.contains("TOKYO") {
            return "WH-TOKYO"
        }

        if normalizedCode.contains("OSAKA") {
            return "WH-OSAKA"
        }

        if normalizedCode.contains("FUKUOKA") {
            return "WH-FUKUOKA"
        }

        return normalizedCode
    }
}

struct AppUser: Identifiable, Equatable {
    let id: String
    let userCode: String
    let userName: String
    let warehouseId: String
}

final class UserSession: ObservableObject {
    @Published private(set) var currentUser: AppUser?
    @Published private(set) var currentWarehouse: Warehouse?
    @Published private(set) var authenticationSource: AuthenticationSource = .sample
    @Published private(set) var dataRefreshKey: Int = 0

    var isLoggedIn: Bool {
        currentUser != nil && currentWarehouse != nil
    }

    var usesWebAPI: Bool {
        authenticationSource == .webAPI
    }

    func login(userCode: String, password: String) async throws {
        let trimmedUserCode = userCode.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedUserCode = trimmedUserCode.uppercased()

        guard !normalizedUserCode.isEmpty, !password.isEmpty else {
            throw UserSessionError.invalidCredentials
        }

        guard let user = sampleUsers.first(where: { $0.userCode == normalizedUserCode }),
              let warehouse = sampleWarehouses.first(where: { $0.id == user.warehouseId }) else {
            try await loginWithWebAPI(userCode: trimmedUserCode, password: password)
            return
        }

        currentUser = user
        currentWarehouse = warehouse
        authenticationSource = .sample
        dataRefreshKey = 0
        TokenManager.clear()
    }

    func logout() {
        currentUser = nil
        currentWarehouse = nil
        authenticationSource = .sample
        dataRefreshKey = 0
        TokenManager.clear()
    }

    func markDataUpdated() {
        dataRefreshKey += 1
    }

    private func loginWithWebAPI(userCode: String, password: String) async throws {
        try await StockerAPIService.shared.checkHealth()
        let response = try await StockerAPIService.shared.login(userCode: userCode, password: password)

        let scopeId = Warehouse.scopeId(for: response.warehouse.warehouseCode)

        currentUser = AppUser(
            id: response.user.userId.uuidString,
            userCode: response.user.userCode,
            userName: response.user.userName,
            warehouseId: scopeId
        )
        currentWarehouse = Warehouse(
            id: scopeId,
            code: response.warehouse.warehouseCode,
            name: response.warehouse.warehouseName,
            apiWarehouseId: response.warehouse.warehouseId.uuidString
        )
        authenticationSource = .webAPI
        dataRefreshKey = 0
        TokenManager.save(token: response.accessToken)
    }
}

enum AuthenticationSource {
    case sample
    case webAPI
}

enum UserSessionError: LocalizedError {
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "ログインに失敗しました。サンプルでは USER1 から USER5、Web API では有効なユーザーを入力してください。"
        }
    }
}

let sampleWarehouses: [Warehouse] = [
    Warehouse(id: "WH-TOKYO", code: "TOKYO", name: "東京倉庫", apiWarehouseId: nil),
    Warehouse(id: "WH-OSAKA", code: "OSAKA", name: "大阪倉庫", apiWarehouseId: nil),
    Warehouse(id: "WH-FUKUOKA", code: "FUKUOKA", name: "福岡倉庫", apiWarehouseId: nil)
]

let sampleUsers: [AppUser] = [
    AppUser(id: "U001", userCode: "USER1", userName: "山田 太郎", warehouseId: "WH-TOKYO"),
    AppUser(id: "U002", userCode: "USER2", userName: "佐藤 花子", warehouseId: "WH-TOKYO"),
    AppUser(id: "U003", userCode: "USER3", userName: "高橋 健", warehouseId: "WH-OSAKA"),
    AppUser(id: "U004", userCode: "USER4", userName: "中村 彩", warehouseId: "WH-OSAKA"),
    AppUser(id: "U005", userCode: "USER5", userName: "井上 拓也", warehouseId: "WH-FUKUOKA")
]
