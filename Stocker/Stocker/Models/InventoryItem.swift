import SwiftUI

struct InventoryItem: Identifiable {
    let id = UUID()
    let location: String
    let itemCode: String
    let itemName: String
    let quantity: Int
    let history: [InventoryHistory]
}

struct InventoryHistory: Identifiable {
    let id = UUID()
    let movementDate: Date
    let quantity: Int
    let executedBy: String
}

let sampleInventoryItems: [InventoryItem] = [
    InventoryItem(location: "A-01", itemCode: "P001", itemName: "りんご", quantity: 10, history: [
        InventoryHistory(movementDate: Date(), quantity: 3, executedBy: "山田"),
        InventoryHistory(movementDate: Date().addingTimeInterval(-86400), quantity: -1, executedBy: "佐藤"),
        InventoryHistory(movementDate: Date().addingTimeInterval(-172800), quantity: 2, executedBy: "鈴木")
    ]),
    InventoryItem(location: "B-02", itemCode: "P002", itemName: "みかん", quantity: 5, history: [
        InventoryHistory(movementDate: Date().addingTimeInterval(-86400 * 2), quantity: 2, executedBy: "田中"),
        InventoryHistory(movementDate: Date().addingTimeInterval(-86400 * 3), quantity: -1, executedBy: "佐藤")
    ]),
    InventoryItem(location: "C-03", itemCode: "P003", itemName: "バナナ", quantity: 8, history: [
        InventoryHistory(movementDate: Date(), quantity: 4, executedBy: "高橋"),
        InventoryHistory(movementDate: Date().addingTimeInterval(-86400), quantity: -2, executedBy: "田中")
    ]),
    InventoryItem(location: "D-01", itemCode: "P004", itemName: "ぶどう", quantity: 12, history: [
        InventoryHistory(movementDate: Date().addingTimeInterval(-86400), quantity: 6, executedBy: "山本"),
        InventoryHistory(movementDate: Date().addingTimeInterval(-86400 * 2), quantity: -3, executedBy: "加藤")
    ]),
    InventoryItem(location: "E-05", itemCode: "P005", itemName: "メロン", quantity: 3, history: [
        InventoryHistory(movementDate: Date(), quantity: 1, executedBy: "中村"),
        InventoryHistory(movementDate: Date().addingTimeInterval(-86400 * 3), quantity: -1, executedBy: "佐々木")
    ]),
    InventoryItem(location: "F-02", itemCode: "P006", itemName: "もも", quantity: 14, history: [
        InventoryHistory(movementDate: Date().addingTimeInterval(-3600 * 5), quantity: 5, executedBy: "井上"),
        InventoryHistory(movementDate: Date().addingTimeInterval(-86400), quantity: -2, executedBy: "山田"),
        InventoryHistory(movementDate: Date().addingTimeInterval(-86400 * 2), quantity: 4, executedBy: "高橋")
    ]),
    InventoryItem(location: "G-04", itemCode: "P007", itemName: "いちご", quantity: 9, history: [
        InventoryHistory(movementDate: Date().addingTimeInterval(-3600 * 8), quantity: -1, executedBy: "佐藤"),
        InventoryHistory(movementDate: Date().addingTimeInterval(-86400), quantity: 3, executedBy: "中村"),
        InventoryHistory(movementDate: Date().addingTimeInterval(-86400 * 4), quantity: 2, executedBy: "田中")
    ]),
    InventoryItem(location: "H-03", itemCode: "P008", itemName: "キウイ", quantity: 6, history: [
        InventoryHistory(movementDate: Date().addingTimeInterval(-3600 * 3), quantity: 2, executedBy: "鈴木"),
        InventoryHistory(movementDate: Date().addingTimeInterval(-86400 * 2), quantity: -1, executedBy: "加藤"),
        InventoryHistory(movementDate: Date().addingTimeInterval(-86400 * 5), quantity: 3, executedBy: "山本")
    ]),
    InventoryItem(location: "I-01", itemCode: "P009", itemName: "パイナップル", quantity: 4, history: [
        InventoryHistory(movementDate: Date().addingTimeInterval(-3600 * 10), quantity: 1, executedBy: "佐々木"),
        InventoryHistory(movementDate: Date().addingTimeInterval(-86400), quantity: -1, executedBy: "井上"),
        InventoryHistory(movementDate: Date().addingTimeInterval(-86400 * 3), quantity: 2, executedBy: "中村")
    ]),
    InventoryItem(location: "J-06", itemCode: "P010", itemName: "レモン", quantity: 11, history: [
        InventoryHistory(movementDate: Date().addingTimeInterval(-3600 * 6), quantity: 4, executedBy: "田中"),
        InventoryHistory(movementDate: Date().addingTimeInterval(-86400 * 2), quantity: -2, executedBy: "高橋"),
        InventoryHistory(movementDate: Date().addingTimeInterval(-86400 * 6), quantity: 5, executedBy: "山田")
    ])
]
