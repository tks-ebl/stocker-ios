
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
            ShippingItem(id: "001", location: "A-01", code: "IT001", name: "六角ボルト", quantity: 10, actual: 8),
            ShippingItem(id: "002", location: "A-02", code: "IT002", name: "ナット", quantity: 15, actual: 15),
            ShippingItem(id: "003", location: "A-03", code: "IT003", name: "スパナ", quantity: 5, actual: 5)
        ]
    ),
    ShippingPlan(
        id: "SP002", destinationCode: "C002", destinationName: "大阪配送", itemCount: 5,
        items: [
            ShippingItem(id: "004", location: "B-01", code: "IT004", name: "レンチ", quantity: 8, actual: 8),
            ShippingItem(id: "005", location: "B-01", code: "IT005", name: "ドライバー", quantity: 12, actual: 10),
            ShippingItem(id: "006", location: "B-02", code: "IT006", name: "プライヤー", quantity: 6, actual: nil),
            ShippingItem(id: "007", location: "B-03", code: "IT007", name: "ハンマー", quantity: 4, actual: 2),
            ShippingItem(id: "008", location: "B-03", code: "IT008", name: "カッター", quantity: 9, actual: 9)
        ]
    ),
    ShippingPlan(
        id: "SP003", destinationCode: "C003", destinationName: "名古屋営業所", itemCount: 2,
        items: [
            ShippingItem(id: "009", location: "C-01", code: "IT009", name: "絶縁テープ", quantity: 7, actual: 7),
            ShippingItem(id: "010", location: "C-01", code: "IT010", name: "ゴーグル", quantity: 3, actual: 3)
        ]
    ),
    ShippingPlan(
        id: "SP004", destinationCode: "C004", destinationName: "福岡支店", itemCount: 6,
        items: [
            ShippingItem(id: "011", location: "D-01", code: "IT011", name: "手袋", quantity: 6, actual: 6),
            ShippingItem(id: "012", location: "D-01", code: "IT012", name: "マスク", quantity: 10, actual: 9),
            ShippingItem(id: "013", location: "D-02", code: "IT013", name: "作業着", quantity: 5, actual: 5),
            ShippingItem(id: "014", location: "D-02", code: "IT014", name: "安全靴", quantity: 4, actual: 4),
            ShippingItem(id: "015", location: "D-03", code: "IT015", name: "ライト", quantity: 3, actual: 2),
            ShippingItem(id: "016", location: "D-03", code: "IT016", name: "ヘルメット", quantity: 2, actual: nil)
        ]
    ),
    ShippingPlan(
        id: "SP005", destinationCode: "C005", destinationName: "札幌倉庫", itemCount: 4,
        items: [
            ShippingItem(id: "017", location: "E-01", code: "IT017", name: "測定器", quantity: 2, actual: 2),
            ShippingItem(id: "018", location: "E-01", code: "IT018", name: "ラチェット", quantity: 5, actual: 5),
            ShippingItem(id: "019", location: "E-02", code: "IT019", name: "ゲージ", quantity: 7, actual: 6),
            ShippingItem(id: "020", location: "E-02", code: "IT020", name: "ケーブル", quantity: 3, actual: 3)
        ]
    ),
    ShippingPlan(
        id: "SP006", destinationCode: "C006", destinationName: "仙台営業所", itemCount: 3,
        items: [
            ShippingItem(id: "021", location: "F-01", code: "IT021", name: "マルチツール", quantity: 4, actual: nil),
            ShippingItem(id: "022", location: "F-02", code: "IT022", name: "テスター", quantity: 6, actual: 6),
            ShippingItem(id: "023", location: "F-02", code: "IT023", name: "シール材", quantity: 2, actual: 2)
        ]
    ),
    ShippingPlan(
        id: "SP007", destinationCode: "C007", destinationName: "広島支社", itemCount: 7,
        items: [
            ShippingItem(id: "024", location: "G-01", code: "IT024", name: "ブレーカー", quantity: 5, actual: 5),
            ShippingItem(id: "025", location: "G-01", code: "IT025", name: "スイッチ", quantity: 4, actual: 3),
            ShippingItem(id: "026", location: "G-02", code: "IT026", name: "ヒューズ", quantity: 6, actual: 6),
            ShippingItem(id: "027", location: "G-02", code: "IT027", name: "リレー", quantity: 3, actual: 2),
            ShippingItem(id: "028", location: "G-03", code: "IT028", name: "端子", quantity: 9, actual: 9),
            ShippingItem(id: "029", location: "G-03", code: "IT029", name: "コネクタ", quantity: 7, actual: 6),
            ShippingItem(id: "030", location: "G-03", code: "IT030", name: "ハーネス", quantity: 8, actual: 8)
        ]
    ),
    ShippingPlan(
        id: "SP008", destinationCode: "C008", destinationName: "金沢センター", itemCount: 2,
        items: [
            ShippingItem(id: "031", location: "H-01", code: "IT031", name: "テープ", quantity: 10, actual: 10),
            ShippingItem(id: "032", location: "H-01", code: "IT032", name: "ラベル", quantity: 6, actual: 5)
        ]
    ),
    ShippingPlan(
        id: "SP009", destinationCode: "C009", destinationName: "那覇デポ", itemCount: 1,
        items: [
            ShippingItem(id: "033", location: "I-01", code: "IT033", name: "封筒", quantity: 3, actual: nil)
        ]
    ),
    ShippingPlan(
        id: "SP010", destinationCode: "C010", destinationName: "横浜物流拠点", itemCount: 5,
        items: [
            ShippingItem(id: "034", location: "J-01", code: "IT034", name: "名札", quantity: 2, actual: 2),
            ShippingItem(id: "035", location: "J-01", code: "IT035", name: "ストラップ", quantity: 4, actual: 4),
            ShippingItem(id: "036", location: "J-02", code: "IT036", name: "ホッチキス", quantity: 1, actual: nil),
            ShippingItem(id: "037", location: "J-02", code: "IT037", name: "はさみ", quantity: 2, actual: 2),
            ShippingItem(id: "038", location: "J-03", code: "IT038", name: "ファイル", quantity: 3, actual: 3)
        ]
    )
]
