// ShippingResultViewModel.swift

import Foundation
import SwiftUI

class ShippingResultViewModel: ObservableObject {
    @Published var allResults: [ShippingResult] = [
        ShippingResult(id: UUID(), itemName: "ねじ", quantity: 10, date: Date(), userCode: "USER1"),
        ShippingResult(id: UUID(), itemName: "ボルト", quantity: 5, date: Date(), userCode: "user2"),
        ShippingResult(id: UUID(), itemName: "ナット", quantity: 8, date: Date(), userCode: "User1")
    ]
    
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
