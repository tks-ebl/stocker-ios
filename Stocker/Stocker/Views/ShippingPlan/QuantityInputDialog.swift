import SwiftUI

struct QuantityInputDialog: View {
    let item: ShippingItem
    let onComplete: (Int) -> Void

    @State private var inputQuantity: String = ""
    @State private var warningMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text("📦 出荷品目")
                    .font(.title2.bold())
                    .padding(.bottom, 8)

                InfoRow(label: "品目名", value: item.name)
                InfoRow(label: "予定数", value: "\(item.quantity)")
                InfoRow(label: "実績", value: "\(item.actual ?? 0)")
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))

            VStack(spacing: 12) {
                Text("実績数を入力")
                    .font(.headline)

                TextField("数量を入力", text: $inputQuantity)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.accentColor, lineWidth: 1))
                    .frame(maxWidth: .infinity)

                if let message = warningMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text(message)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    .padding(.top, 4)
                }

                HStack {
                    Button(action: {
                        onComplete(item.actual ?? 0)
                    }) {
                        Text("キャンセル")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))
                    }

                    Button(action: {
                        validateAndComplete()
                    }) {
                        Text("完了")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.top)
        }
        .padding()
        .onAppear {
            if let actual = item.actual, actual > 0 {
                inputQuantity = String(actual)
            }
        }
    }

    private func validateAndComplete() {
        guard let actual = Int(inputQuantity), actual >= 0 else {
            warningMessage = "正の整数を入力してください"
            return
        }

        if actual != item.quantity {
            warningMessage = "⚠️ 実績数が予定と異なります"
        } else {
            warningMessage = nil
        }

        onComplete(actual)
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body.bold())
        }
    }
}
