
struct ShippingPlan: Identifiable {
    let id: String
    let warehouseId: String
    let destinationCode: String
    let destinationName: String
    let itemCount: Int
    let items: [ShippingItem]?
}

struct ShippingItem: Identifiable, Equatable {
    let id: String
    let location: String
    let code: String
    let name: String
    let quantity: Int
    var actual: Int?
}


let sampleShippingPlans: [ShippingPlan] = [
    ShippingPlan(
        id: "SP001", warehouseId: "WH-TOKYO", destinationCode: "C001", destinationName: "丸の内青果店", itemCount: 3,
        items: [
            ShippingItem(id: "001", location: "A-01", code: "P001", name: "りんご", quantity: 4, actual: 3),
            ShippingItem(id: "002", location: "B-02", code: "P002", name: "みかん", quantity: 2, actual: 2),
            ShippingItem(id: "003", location: "C-03", code: "P003", name: "バナナ", quantity: 3, actual: 2)
        ]
    ),
    ShippingPlan(
        id: "SP002", warehouseId: "WH-TOKYO", destinationCode: "C002", destinationName: "神田フルーツ", itemCount: 5,
        items: [
            ShippingItem(id: "004", location: "D-01", code: "P004", name: "ぶどう", quantity: 6, actual: 6),
            ShippingItem(id: "005", location: "E-05", code: "P005", name: "メロン", quantity: 1, actual: 1),
            ShippingItem(id: "006", location: "F-02", code: "P006", name: "もも", quantity: 5, actual: nil),
            ShippingItem(id: "007", location: "G-04", code: "P007", name: "いちご", quantity: 4, actual: 3),
            ShippingItem(id: "008", location: "H-03", code: "P008", name: "キウイ", quantity: 2, actual: 2)
        ]
    ),
    ShippingPlan(
        id: "SP003", warehouseId: "WH-TOKYO", destinationCode: "C003", destinationName: "銀座マルシェ", itemCount: 2,
        items: [
            ShippingItem(id: "009", location: "I-01", code: "P009", name: "パイナップル", quantity: 2, actual: 2),
            ShippingItem(id: "010", location: "J-06", code: "P010", name: "レモン", quantity: 4, actual: 3)
        ]
    ),
    ShippingPlan(
        id: "SP004", warehouseId: "WH-OSAKA", destinationCode: "C004", destinationName: "梅田青果", itemCount: 6,
        items: [
            ShippingItem(id: "011", location: "A-01", code: "P001", name: "りんご", quantity: 5, actual: 5),
            ShippingItem(id: "012", location: "C-03", code: "P003", name: "バナナ", quantity: 4, actual: 3),
            ShippingItem(id: "013", location: "D-01", code: "P004", name: "ぶどう", quantity: 3, actual: 3),
            ShippingItem(id: "014", location: "F-02", code: "P006", name: "もも", quantity: 6, actual: 5),
            ShippingItem(id: "015", location: "G-04", code: "P007", name: "いちご", quantity: 2, actual: 1),
            ShippingItem(id: "016", location: "J-06", code: "P010", name: "レモン", quantity: 3, actual: nil)
        ]
    ),
    ShippingPlan(
        id: "SP005", warehouseId: "WH-OSAKA", destinationCode: "C005", destinationName: "なんば市場", itemCount: 4,
        items: [
            ShippingItem(id: "017", location: "B-02", code: "P002", name: "みかん", quantity: 2, actual: 2),
            ShippingItem(id: "018", location: "E-05", code: "P005", name: "メロン", quantity: 1, actual: 1),
            ShippingItem(id: "019", location: "H-03", code: "P008", name: "キウイ", quantity: 3, actual: 2),
            ShippingItem(id: "020", location: "I-01", code: "P009", name: "パイナップル", quantity: 2, actual: 2)
        ]
    ),
    ShippingPlan(
        id: "SP006", warehouseId: "WH-OSAKA", destinationCode: "C006", destinationName: "新大阪ストア", itemCount: 3,
        items: [
            ShippingItem(id: "021", location: "A-01", code: "P001", name: "りんご", quantity: 3, actual: nil),
            ShippingItem(id: "022", location: "F-02", code: "P006", name: "もも", quantity: 4, actual: 4),
            ShippingItem(id: "023", location: "J-06", code: "P010", name: "レモン", quantity: 2, actual: 2)
        ]
    ),
    ShippingPlan(
        id: "SP007", warehouseId: "WH-FUKUOKA", destinationCode: "C007", destinationName: "博多フード", itemCount: 7,
        items: [
            ShippingItem(id: "024", location: "A-01", code: "P001", name: "りんご", quantity: 2, actual: 2),
            ShippingItem(id: "025", location: "B-02", code: "P002", name: "みかん", quantity: 2, actual: 1),
            ShippingItem(id: "026", location: "C-03", code: "P003", name: "バナナ", quantity: 3, actual: 3),
            ShippingItem(id: "027", location: "D-01", code: "P004", name: "ぶどう", quantity: 4, actual: 3),
            ShippingItem(id: "028", location: "G-04", code: "P007", name: "いちご", quantity: 5, actual: 5),
            ShippingItem(id: "029", location: "H-03", code: "P008", name: "キウイ", quantity: 2, actual: 2),
            ShippingItem(id: "030", location: "I-01", code: "P009", name: "パイナップル", quantity: 1, actual: 1)
        ]
    ),
    ShippingPlan(
        id: "SP008", warehouseId: "WH-FUKUOKA", destinationCode: "C008", destinationName: "天神マルシェ", itemCount: 2,
        items: [
            ShippingItem(id: "031", location: "E-05", code: "P005", name: "メロン", quantity: 1, actual: 1),
            ShippingItem(id: "032", location: "F-02", code: "P006", name: "もも", quantity: 3, actual: 2)
        ]
    ),
    ShippingPlan(
        id: "SP009", warehouseId: "WH-FUKUOKA", destinationCode: "C009", destinationName: "小倉青果", itemCount: 1,
        items: [
            ShippingItem(id: "033", location: "G-04", code: "P007", name: "いちご", quantity: 2, actual: nil)
        ]
    ),
    ShippingPlan(
        id: "SP010", warehouseId: "WH-FUKUOKA", destinationCode: "C010", destinationName: "久留米ストア", itemCount: 5,
        items: [
            ShippingItem(id: "034", location: "B-02", code: "P002", name: "みかん", quantity: 1, actual: 1),
            ShippingItem(id: "035", location: "C-03", code: "P003", name: "バナナ", quantity: 2, actual: 2),
            ShippingItem(id: "036", location: "H-03", code: "P008", name: "キウイ", quantity: 2, actual: nil),
            ShippingItem(id: "037", location: "I-01", code: "P009", name: "パイナップル", quantity: 1, actual: 1),
            ShippingItem(id: "038", location: "J-06", code: "P010", name: "レモン", quantity: 3, actual: 3)
        ]
    )
]
