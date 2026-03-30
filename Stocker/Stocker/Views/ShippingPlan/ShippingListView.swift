import SwiftUI

struct ShippingListView: View {
    @EnvironmentObject var userSession: UserSession
    let selectedDate: Date
    let customerCode: String
    
    @State private var shippingID = ""
    @State private var selectedPlan: ShippingPlan?
    @State private var isNextActive = false
    @State private var isShowingQRScanner = false  // QR画面表示制御

    var plans: [ShippingPlan] {
        guard let warehouseId = userSession.currentWarehouse?.id else {
            return []
        }

        return sampleShippingPlans.filter { plan in
            guard plan.warehouseId == warehouseId else {
                return false
            }

            if customerCode.isEmpty {
                return true
            }

            return plan.destinationCode.localizedCaseInsensitiveContains(customerCode)
        }
    }

    var body: some View {
        VStack {
            HStack {
                TextField("出荷IDを入力", text: $shippingID)
                    .textFieldStyle(.roundedBorder)
                
                Button(action: {
                    isShowingQRScanner = true
                }) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.title2)
                        .padding(8)
                        .background(Color.appPrimary.opacity(0.1))
                        .cornerRadius(8)
                }
                .sheet(isPresented: $isShowingQRScanner) {
                    QRCodeScannerView { result in
                        switch result {
                        case .success(let code):
                            shippingID = code
                        case .failure(let error):
                            print("QR読み取りエラー: \(error.localizedDescription)")
                        }
                        isShowingQRScanner = false
                    }
                }
            }
            .padding()

            if plans.isEmpty {
                ContentUnavailableView(
                    "出荷プランがありません",
                    systemImage: "tray",
                    description: Text("選択した倉庫と条件に一致する出荷プランがありません。")
                )
            } else {
                List(plans) { plan in
                    Button {
                        selectedPlan = plan
                        isNextActive = true
                    } label: {
                        VStack(alignment: .leading) {
                            Text(plan.destinationName)
                                .font(.headline)
                            Text("品目数: \(plan.itemCount)")
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        // タイトル表示
        .navigationTitle("🚚梱包リスト")
        //　画面遷移
        .navigationDestination(isPresented: $isNextActive) {
            if let plan = selectedPlan {
                ShippingDetailLotListView(selectedPlan: plan)
            }
        }
        //　画面遷移（ダイアログ）
        .fullScreenCover(isPresented: $isShowingQRScanner) {
            ZStack(alignment: .topLeading) {
                QRCodeScannerView { result in
                    switch result {
                    case .success(let code):
                        shippingID = code
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
    }
}
