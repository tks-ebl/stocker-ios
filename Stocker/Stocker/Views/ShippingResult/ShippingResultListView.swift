import SwiftUI

extension URL: @retroactive Identifiable {
    public var id: String { self.absoluteString }
}

struct ShippingResultListView: View {
    let date: Date
    let userCode: String
    let warehouseId: String

    @StateObject private var viewModel: ShippingResultViewModel
    @State private var exportURL: URL? = nil

    init(date: Date, userCode: String, warehouseId: String) {
        self.date = date
        self.userCode = userCode
        self.warehouseId = warehouseId
        _viewModel = StateObject(wrappedValue: ShippingResultViewModel(warehouseId: warehouseId))
    }

    var filteredResults: [ShippingResult] {
        viewModel.filteredResults(for: date, userCode: userCode)
    }

    var body: some View {
        VStack {
            HStack {
                Text("件数: \(filteredResults.count) 件")
                    .font(.subheadline)
                    .padding(.leading)

                Spacer()

                Button(action: {
                    if let url = viewModel.exportCSV(for: filteredResults) {
                        exportURL = url
                    }
                }) {
                    Label("CSV出力", systemImage: "square.and.arrow.up")
                        .font(.caption)
                }
                .padding(.trailing)
            }

            if filteredResults.isEmpty {
                ContentUnavailableView(
                    "出荷実績がありません",
                    systemImage: "shippingbox",
                    description: Text("指定した条件に一致する出荷実績がありません。")
                )
            } else {
                List {
                    ForEach(filteredResults) { result in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(result.itemName)
                                    .font(.headline)
                                Text("ユーザー: \(result.userCode)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\(result.quantity) 個")
                                    .font(.title3.bold())
                                Text(dateFormatted(result.date))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.delete(result)
                            } label: {
                                Label("削除", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $exportURL) { url in
            ShareSheet(activityItems: [url])
        }
        .navigationTitle("🚚 出荷実績リスト")
    }

    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年MM月dd日"
        return formatter.string(from: date)
    }
}
