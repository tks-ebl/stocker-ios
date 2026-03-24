// ShippingResultViewModel.swift

import Foundation
import SwiftUI

class ShippingResultViewModel: ObservableObject {
    @Published var allResults: [ShippingResult] = ShippingResultViewModel.makeWeeklyResults()
    
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

    private static func makeWeeklyResults() -> [ShippingResult] {
        [
            makeResult(itemName: "りんご", quantity: 3, userCode: "USER1", dayOffset: 0, hour: 9, minute: 15),
            makeResult(itemName: "みかん", quantity: 2, userCode: "USER2", dayOffset: 0, hour: 11, minute: 40),
            makeResult(itemName: "バナナ", quantity: 4, userCode: "USER3", dayOffset: 0, hour: 15, minute: 5),

            makeResult(itemName: "ぶどう", quantity: 5, userCode: "USER2", dayOffset: 1, hour: 10, minute: 20),
            makeResult(itemName: "メロン", quantity: 1, userCode: "USER4", dayOffset: 1, hour: 13, minute: 10),

            makeResult(itemName: "もも", quantity: 6, userCode: "USER1", dayOffset: 2, hour: 8, minute: 50),
            makeResult(itemName: "いちご", quantity: 3, userCode: "USER5", dayOffset: 2, hour: 12, minute: 30),
            makeResult(itemName: "キウイ", quantity: 2, userCode: "USER3", dayOffset: 2, hour: 16, minute: 45),
            makeResult(itemName: "りんご", quantity: 1, userCode: "USER2", dayOffset: 2, hour: 17, minute: 20),

            makeResult(itemName: "パイナップル", quantity: 2, userCode: "USER4", dayOffset: 3, hour: 9, minute: 35),
            makeResult(itemName: "レモン", quantity: 4, userCode: "USER1", dayOffset: 3, hour: 14, minute: 0),
            makeResult(itemName: "みかん", quantity: 1, userCode: "USER5", dayOffset: 3, hour: 17, minute: 10),

            makeResult(itemName: "バナナ", quantity: 2, userCode: "USER2", dayOffset: 4, hour: 10, minute: 5),
            makeResult(itemName: "ぶどう", quantity: 3, userCode: "USER3", dayOffset: 4, hour: 11, minute: 55),
            makeResult(itemName: "もも", quantity: 4, userCode: "USER4", dayOffset: 4, hour: 15, minute: 25),
            makeResult(itemName: "キウイ", quantity: 1, userCode: "USER1", dayOffset: 4, hour: 18, minute: 10),

            makeResult(itemName: "いちご", quantity: 5, userCode: "USER5", dayOffset: 5, hour: 9, minute: 0),
            makeResult(itemName: "レモン", quantity: 2, userCode: "USER2", dayOffset: 5, hour: 13, minute: 45),

            makeResult(itemName: "メロン", quantity: 1, userCode: "USER3", dayOffset: 6, hour: 10, minute: 15),
            makeResult(itemName: "パイナップル", quantity: 2, userCode: "USER4", dayOffset: 6, hour: 12, minute: 50),
            makeResult(itemName: "りんご", quantity: 3, userCode: "USER1", dayOffset: 6, hour: 16, minute: 5)
        ]
    }

    private static func makeResult(
        itemName: String,
        quantity: Int,
        userCode: String,
        dayOffset: Int,
        hour: Int,
        minute: Int
    ) -> ShippingResult {
        ShippingResult(
            id: UUID(),
            itemName: itemName,
            quantity: quantity,
            date: makeDate(dayOffset: dayOffset, hour: hour, minute: minute),
            userCode: userCode
        )
    }

    private static func makeDate(dayOffset: Int, hour: Int, minute: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let today = Date()
        let startOfToday = calendar.startOfDay(for: today)
        let weekday = calendar.component(.weekday, from: startOfToday)
        let mondayOffset = (weekday + 5) % 7
        let startOfWeek = calendar.date(byAdding: .day, value: -mondayOffset, to: startOfToday) ?? startOfToday
        let targetDay = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) ?? startOfWeek
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: targetDay) ?? targetDay
    }
}
