import Foundation

struct Warehouse: Identifiable, Equatable {
    let id: String
    let code: String
    let name: String
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

    var isLoggedIn: Bool {
        currentUser != nil && currentWarehouse != nil
    }

    func login(userCode: String, password: String) -> Bool {
        let normalizedUserCode = userCode.uppercased()
        guard !normalizedUserCode.isEmpty, !password.isEmpty else {
            return false
        }

        guard let user = sampleUsers.first(where: { $0.userCode == normalizedUserCode }),
              let warehouse = sampleWarehouses.first(where: { $0.id == user.warehouseId }) else {
            return false
        }

        currentUser = user
        currentWarehouse = warehouse
        return true
    }

    func logout() {
        currentUser = nil
        currentWarehouse = nil
    }
}

let sampleWarehouses: [Warehouse] = [
    Warehouse(id: "WH-TOKYO", code: "TOKYO", name: "東京倉庫"),
    Warehouse(id: "WH-OSAKA", code: "OSAKA", name: "大阪倉庫"),
    Warehouse(id: "WH-FUKUOKA", code: "FUKUOKA", name: "福岡倉庫")
]

let sampleUsers: [AppUser] = [
    AppUser(id: "U001", userCode: "USER1", userName: "山田 太郎", warehouseId: "WH-TOKYO"),
    AppUser(id: "U002", userCode: "USER2", userName: "佐藤 花子", warehouseId: "WH-TOKYO"),
    AppUser(id: "U003", userCode: "USER3", userName: "高橋 健", warehouseId: "WH-OSAKA"),
    AppUser(id: "U004", userCode: "USER4", userName: "中村 彩", warehouseId: "WH-OSAKA"),
    AppUser(id: "U005", userCode: "USER5", userName: "井上 拓也", warehouseId: "WH-FUKUOKA")
]
