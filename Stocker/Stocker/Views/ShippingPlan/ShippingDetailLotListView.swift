import SwiftUI

struct ShippingDetailLotListView: View {
    @EnvironmentObject var userSession: UserSession
    let selectedPlan: ShippingPlan

    @Environment(\.presentationMode) var presentationMode

    @State private var inputCode: String = ""
    @State private var highlightedIDs: Set<String> = []
    @State private var isShowingQRScanner = false
    @State private var selectedItem: ShippingItem?
    @State private var workingItems: [ShippingItem] = []
    @State private var showCompletionAlert = false
    @State private var saveErrorMessage: String?
    @State private var isSaving = false
    @State private var didSaveSuccessfully = false

    var items: [ShippingItem] {
        workingItems
    }

    var groupedItems: [String: [ShippingItem]] {
        Dictionary(grouping: items, by: { $0.location })
    }

    var canSubmitResults: Bool {
        !items.isEmpty && items.allSatisfy { ($0.actual ?? 0) > 0 }
    }

    var body: some View {
        VStack {
            // 入力欄 + QRボタン
            HStack {
                TextField("品目コードを入力", text: $inputCode)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        handleSearch(code: inputCode)
                    }

                Button(action: {
                    isShowingQRScanner = true
                }) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.title2)
                        .padding(8)
                        .background(Color.appPrimary.opacity(0.1))
                        .cornerRadius(8)
                }

                Button("検索") {
                    handleSearch(code: inputCode)
                }
            }
            .padding()

            if let saveErrorMessage {
                Text(saveErrorMessage)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            List {
                ForEach(groupedItems.keys.sorted(), id: \.self) { location in
                    Section(header: Text("ロケ: \(location)").font(.headline)) {
                        ForEach(groupedItems[location] ?? []) { item in
                            let backgroundColor = backgroundColorForItem(item)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(item.name) (\(item.code))")
                                        .font(.headline)
                                    Text("予定: \(item.quantity) / 実績: \(item.actual ?? 0)")
                                        .font(.subheadline)
                                    if let actual = item.actual {
                                        let diff = item.quantity - actual
                                        Text("差分: \(diff)")
                                            .font(.caption)
                                            .foregroundColor(diff == 0 ? .gray : .red)
                                    } else {
                                        Text("未入力")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 4)
                            .background(highlightedIDs.contains(item.id) ? Color.yellow.opacity(0.2) : backgroundColor)
                            .cornerRadius(8)
                            .onTapGesture {
                                selectedItem = item
                            }
                        }
                    }
                }
            }

            if userSession.usesWebAPI {
                Button(action: submitResults) {
                    HStack {
                        if isSaving {
                            ProgressView()
                                .progressViewStyle(.circular)
                        } else {
                            Text("出荷実績を登録")
                                .bold()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canSubmitResults ? Color.appPrimary : Color.gray.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(isSaving || !canSubmitResults)
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationTitle("🚚出荷作業")

        // QRコードスキャナ
        .fullScreenCover(isPresented: $isShowingQRScanner) {
            ZStack(alignment: .topLeading) {
                QRCodeScannerView { result in
                    switch result {
                    case .success(let code):
                        handleSearch(code: code)
                    case .failure(let error):
                        print("QR読み取り失敗: \(error.localizedDescription)")
                    }
                    isShowingQRScanner = false
                }

                Button(action: {
                    isShowingQRScanner = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 28))
                        .padding()
                }
            }
        }

        // 数量入力シート
        .sheet(item: $selectedItem) { item in
            QuantityInputDialog(item: item) { newActual in
                updateItem(item, with: newActual)
                selectedItem = nil

                if items.allSatisfy({ $0.actual == $0.quantity }) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        showCompletionAlert = true
                    }
                }
            }
        }

        // 完了アラート & 自動戻る
        .alert("完了", isPresented: $showCompletionAlert) {
            Button("OK") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text(didSaveSuccessfully ? "出荷実績を登録しました。" : "すべての出荷品目が完了しました。")
        }

        .onAppear {
            workingItems = selectedPlan.items ?? []
        }
    }

    // 実績更新
    private func updateItem(_ item: ShippingItem, with actual: Int) {
        if let index = workingItems.firstIndex(where: { $0.id == item.id }) {
            workingItems[index].actual = actual
        }
    }

    private func submitResults() {
        guard userSession.usesWebAPI else {
            return
        }

        guard canSubmitResults else {
            saveErrorMessage = "すべての品目に実績数を入力してください。"
            return
        }

        guard let apiWarehouseId = userSession.currentWarehouse?.apiWarehouseId,
              let token = TokenManager.load() else {
            saveErrorMessage = "Web API の認証情報が見つかりません。"
            return
        }

        isSaving = true
        saveErrorMessage = nil

        Task {
            do {
                _ = try await StockerAPIService.shared.createShippingResults(
                    warehouseId: apiWarehouseId,
                    shippingPlanId: selectedPlan.id,
                    destinationCode: selectedPlan.destinationCode,
                    items: items,
                    bearerToken: token
                )

                await MainActor.run {
                    isSaving = false
                    didSaveSuccessfully = true
                    showCompletionAlert = true
                }
            } catch {
                await MainActor.run {
                    isSaving = false
                    saveErrorMessage = error.localizedDescription
                }
            }
        }
    }

    // 検索処理
    private func handleSearch(code: String) {
        guard !code.isEmpty else {
            highlightedIDs = []
            return
        }
        let matches = items.filter {
            $0.code.localizedCaseInsensitiveContains(code) ||
            $0.name.localizedCaseInsensitiveContains(code) ||
            $0.location.localizedCaseInsensitiveContains(code)
        }
        highlightedIDs = Set(matches.map { $0.id })

        if let first = matches.first {
            selectedItem = first
        }
    }

    // 背景色ロジック
    private func backgroundColorForItem(_ item: ShippingItem) -> Color {
        if item.actual == nil {
            return Color.gray.opacity(0.1)   // 未処理
        } else if item.actual != item.quantity {
            return Color.yellow.opacity(0.2) // 差分あり
        } else {
            return Color.green.opacity(0.2)  // 完了
        }
    }
}
