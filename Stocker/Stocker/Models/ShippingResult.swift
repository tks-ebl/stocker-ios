import Foundation

struct ShippingResult: Identifiable, Codable {
    let id: UUID
    let itemName: String
    let quantity: Int
    let date: Date
    let userCode: String
}
