// ShippingResultViewModel.swift

import Foundation
import SwiftUI

@MainActor
class ShippingResultViewModel: ObservableObject {
    @Published var allResults: [ShippingResult]
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    init(warehouseId: String) {
        allResults = sampleShippingResults.filter { $0.warehouseId == warehouseId }
    }

    func loadIfNeeded(userSession: UserSession, date: Date, userCode: String) async {
        guard userSession.usesWebAPI else {
            errorMessage = nil
            isLoading = false
            return
        }

        guard let apiWarehouseId = userSession.currentWarehouse?.apiWarehouseId,
              let scopeWarehouseId = userSession.currentWarehouse?.id,
              let token = TokenManager.load() else {
            allResults = []
            errorMessage = "Web API の認証情報が見つかりません。"
            isLoading = false
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            allResults = try await StockerAPIService.shared.fetchShippingResults(
                warehouseId: apiWarehouseId,
                scopeWarehouseId: scopeWarehouseId,
                date: date,
                userCode: userCode,
                bearerToken: token
            )
        } catch {
            allResults = []
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
    
    func delete(_ result: ShippingResult) {
        allResults.removeAll { $0.id == result.id }
    }

    func filteredResults(for date: Date, userCode: String) -> [ShippingResult] {
        allResults.filter {
            Calendar.current.isDate($0.date, inSameDayAs: date) &&
            (userCode.isEmpty || $0.userCode.localizedCaseInsensitiveContains(userCode))
        }
    }

    func exportCSV(for results: [ShippingResult]) -> URL? {
        guard !results.isEmpty else {
            print("⚠️ 出力対象のデータが空です")
            return nil
        }

        let csvHeader = "商品名,数量,ユーザー,日付"
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd"

        let rows = results.map {
            "\($0.itemName),\($0.quantity),\($0.userCode),\(formatter.string(from: $0.date))"
        }

        let csvString = ([csvHeader] + rows).joined(separator: "\n")

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("ShippingResults.csv")
        do {
            try csvString.write(to: tempURL, atomically: true, encoding: .utf8)

            if FileManager.default.fileExists(atPath: tempURL.path) {
                print("✅ CSV書き出し成功: \(tempURL.path)")
            } else {
                print("❌ 書き出し済みだがファイルが存在しない")
            }

            return tempURL
        } catch {
            print("❌ CSV出力エラー: \(error)")
            return nil
        }
    }
}

let sampleShippingResults: [ShippingResult] = makeWeeklyResults()

private func makeWeeklyResults() -> [ShippingResult] {
        [
            makeResult(warehouseId: "WH-TOKYO", itemName: "りんご", quantity: 3, userCode: "USER1", dayOffset: 0, hour: 9, minute: 15),
            makeResult(warehouseId: "WH-TOKYO", itemName: "みかん", quantity: 2, userCode: "USER2", dayOffset: 0, hour: 11, minute: 40),
            makeResult(warehouseId: "WH-TOKYO", itemName: "バナナ", quantity: 4, userCode: "USER1", dayOffset: 2, hour: 15, minute: 5),
            makeResult(warehouseId: "WH-TOKYO", itemName: "ぶどう", quantity: 5, userCode: "USER2", dayOffset: 4, hour: 10, minute: 20),
            makeResult(warehouseId: "WH-TOKYO", itemName: "りんご", quantity: 1, userCode: "USER2", dayOffset: 6, hour: 17, minute: 20),

            makeResult(warehouseId: "WH-OSAKA", itemName: "メロン", quantity: 1, userCode: "USER4", dayOffset: 1, hour: 13, minute: 10),
            makeResult(warehouseId: "WH-OSAKA", itemName: "もも", quantity: 6, userCode: "USER3", dayOffset: 2, hour: 8, minute: 50),
            makeResult(warehouseId: "WH-OSAKA", itemName: "いちご", quantity: 3, userCode: "USER4", dayOffset: 3, hour: 12, minute: 30),
            makeResult(warehouseId: "WH-OSAKA", itemName: "メロン", quantity: 1, userCode: "USER3", dayOffset: 6, hour: 10, minute: 15),
            makeResult(warehouseId: "WH-OSAKA", itemName: "もも", quantity: 4, userCode: "USER4", dayOffset: 4, hour: 15, minute: 25),

            makeResult(warehouseId: "WH-FUKUOKA", itemName: "キウイ", quantity: 2, userCode: "USER5", dayOffset: 2, hour: 16, minute: 45),
            makeResult(warehouseId: "WH-FUKUOKA", itemName: "パイナップル", quantity: 2, userCode: "USER5", dayOffset: 3, hour: 9, minute: 35),
            makeResult(warehouseId: "WH-FUKUOKA", itemName: "レモン", quantity: 4, userCode: "USER5", dayOffset: 3, hour: 14, minute: 0),
            makeResult(warehouseId: "WH-FUKUOKA", itemName: "いちご", quantity: 5, userCode: "USER5", dayOffset: 5, hour: 9, minute: 0),
            makeResult(warehouseId: "WH-FUKUOKA", itemName: "パイナップル", quantity: 2, userCode: "USER5", dayOffset: 6, hour: 12, minute: 50)
        ]
    }

private func makeResult(
        warehouseId: String,
        itemName: String,
        quantity: Int,
        userCode: String,
        dayOffset: Int,
        hour: Int,
        minute: Int
    ) -> ShippingResult {
        ShippingResult(
            id: UUID(),
            warehouseId: warehouseId,
            itemName: itemName,
            quantity: quantity,
            date: makeShippingDate(dayOffset: dayOffset, hour: hour, minute: minute),
            userCode: userCode
        )
    }

private func makeShippingDate(dayOffset: Int, hour: Int, minute: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let today = Date()
        let startOfToday = calendar.startOfDay(for: today)
        let weekday = calendar.component(.weekday, from: startOfToday)
        let mondayOffset = (weekday + 5) % 7
        let startOfWeek = calendar.date(byAdding: .day, value: -mondayOffset, to: startOfToday) ?? startOfToday
        let targetDay = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) ?? startOfWeek
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: targetDay) ?? targetDay
}
