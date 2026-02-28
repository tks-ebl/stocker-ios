import SwiftUI

struct ShippingDetailView: View {
    let plan: ShippingPlan

    @State private var inputCode = ""
    @State private var selectedItem: ShippingItem?
    @State private var showQuantitySheet = false
    @State private var completedItems: Set<String> = []

    @Environment(\.dismiss) var dismiss

    var items: [ShippingItem] {
        [
            ShippingItem(id: "001", location: "A-01", code: "IT001", name: "ねじ", quantity: 10),
            ShippingItem(id: "002", location: "A-02", code: "IT002", name: "ボルト", quantity: 5),
        ]
    }

    var body: some View {
        VStack {
            TextField("品目コードを入力", text: $inputCode)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onSubmit {
                    if let match = items.first(where: { $0.code == inputCode }) {
                        selectedItem = match
                        showQuantitySheet = true
                    }
                }

            List {
                ForEach(items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(item.name) (\(item.code))")
                            Text("ロケ: \(item.location)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("予定: \(item.quantity)")
                            .foregroundColor(.appPrimary)
                    }
                    .opacity(completedItems.contains(item.id) ? 0.4 : 1.0)
                }
            }
        }
        .sheet(isPresented: $showQuantitySheet) {
            if let item = selectedItem {
                QuantityInputDialog(item: item) { confirmed in
                    if confirmed != 0 {
                        completedItems.insert(item.id)
                        inputCode = ""
                        selectedItem = nil
                        showQuantitySheet = false

                        if completedItems.count == items.count {
                            // 全量完了
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showCompletionDialog()
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("出荷品目入力")
    }

    private func showCompletionDialog() {
        let alert = UIAlertController(title: "完了", message: "すべての出荷品目が完了しました。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            dismiss()  // 一つ前の画面へ戻る
        })
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
}
