
struct ShippingPlan: Identifiable {
    let id: String
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
        id: "SP001", destinationCode: "C001", destinationName: "東京倉庫", itemCount: 3,
        items: [
            ShippingItem(id: "001", location: "A-01", code: "P001", name: "りんご", quantity: 4, actual: 3),
            ShippingItem(id: "002", location: "B-02", code: "P002", name: "みかん", quantity: 2, actual: 2),
            ShippingItem(id: "003", location: "C-03", code: "P003", name: "バナナ", quantity: 3, actual: 2)
        ]
    ),
    ShippingPlan(
        id: "SP002", destinationCode: "C002", destinationName: "大阪配送", itemCount: 5,
        items: [
            ShippingItem(id: "004", location: "D-01", code: "P004", name: "ぶどう", quantity: 6, actual: 6),
            ShippingItem(id: "005", location: "E-05", code: "P005", name: "メロン", quantity: 1, actual: 1),
            ShippingItem(id: "006", location: "F-02", code: "P006", name: "もも", quantity: 5, actual: nil),
            ShippingItem(id: "007", location: "G-04", code: "P007", name: "いちご", quantity: 4, actual: 3),
            ShippingItem(id: "008", location: "H-03", code: "P008", name: "キウイ", quantity: 2, actual: 2)
        ]
    ),
    ShippingPlan(
        id: "SP003", destinationCode: "C003", destinationName: "名古屋営業所", itemCount: 2,
        items: [
            ShippingItem(id: "009", location: "I-01", code: "P009", name: "パイナップル", quantity: 2, actual: 2),
            ShippingItem(id: "010", location: "J-06", code: "P010", name: "レモン", quantity: 4, actual: 3)
        ]
    ),
    ShippingPlan(
        id: "SP004", destinationCode: "C004", destinationName: "福岡支店", itemCount: 6,
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
        id: "SP005", destinationCode: "C005", destinationName: "札幌倉庫", itemCount: 4,
        items: [
            ShippingItem(id: "017", location: "B-02", code: "P002", name: "みかん", quantity: 2, actual: 2),
            ShippingItem(id: "018", location: "E-05", code: "P005", name: "メロン", quantity: 1, actual: 1),
            ShippingItem(id: "019", location: "H-03", code: "P008", name: "キウイ", quantity: 3, actual: 2),
            ShippingItem(id: "020", location: "I-01", code: "P009", name: "パイナップル", quantity: 2, actual: 2)
        ]
    ),
    ShippingPlan(
        id: "SP006", destinationCode: "C006", destinationName: "仙台営業所", itemCount: 3,
        items: [
            ShippingItem(id: "021", location: "A-01", code: "P001", name: "りんご", quantity: 3, actual: nil),
            ShippingItem(id: "022", location: "F-02", code: "P006", name: "もも", quantity: 4, actual: 4),
            ShippingItem(id: "023", location: "J-06", code: "P010", name: "レモン", quantity: 2, actual: 2)
        ]
    ),
    ShippingPlan(
        id: "SP007", destinationCode: "C007", destinationName: "広島支社", itemCount: 7,
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
        id: "SP008", destinationCode: "C008", destinationName: "金沢センター", itemCount: 2,
        items: [
            ShippingItem(id: "031", location: "E-05", code: "P005", name: "メロン", quantity: 1, actual: 1),
            ShippingItem(id: "032", location: "F-02", code: "P006", name: "もも", quantity: 3, actual: 2)
        ]
    ),
    ShippingPlan(
        id: "SP009", destinationCode: "C009", destinationName: "那覇デポ", itemCount: 1,
        items: [
            ShippingItem(id: "033", location: "G-04", code: "P007", name: "いちご", quantity: 2, actual: nil)
        ]
    ),
    ShippingPlan(
        id: "SP010", destinationCode: "C010", destinationName: "横浜物流拠点", itemCount: 5,
        items: [
            ShippingItem(id: "034", location: "B-02", code: "P002", name: "みかん", quantity: 1, actual: 1),
            ShippingItem(id: "035", location: "C-03", code: "P003", name: "バナナ", quantity: 2, actual: 2),
            ShippingItem(id: "036", location: "H-03", code: "P008", name: "キウイ", quantity: 2, actual: nil),
            ShippingItem(id: "037", location: "I-01", code: "P009", name: "パイナップル", quantity: 1, actual: 1),
            ShippingItem(id: "038", location: "J-06", code: "P010", name: "レモン", quantity: 3, actual: 3)
        ]
    )
]
