import SwiftUI

struct ShippingStartView: View {
    @EnvironmentObject var menuState: MenuState
    @EnvironmentObject var userSession: UserSession
    @State private var selectedDate = Date()
    @State private var customerCode = ""
    @State private var isNavigating = false

    var body: some View {
        ZStack(alignment: .leading) {
            NavigationStack {
                VStack(alignment: .leading, spacing: 24) {
                    if let warehouse = userSession.currentWarehouse, let user = userSession.currentUser {
                        WarehouseContextView(
                            warehouseName: warehouse.name,
                            userName: user.userName,
                            userCode: user.userCode
                        )
                        .padding(.horizontal)
                    }

                    // 出荷日
                    VStack(alignment: .leading) {
                        Text("出荷日")
                            .font(.headline)
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .environment(\.locale, Locale(identifier: "ja_JP"))  // ← ここを追加
                    }
                    .padding(.horizontal)

                    // 出荷先コード
                    VStack(alignment: .leading) {
                        Text("出荷先コード")
                            .font(.headline)
                        TextField("出荷先コードを入力", text: $customerCode)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.horizontal)

                    Spacer()

                    // 作業開始ボタン
                    Button(action: {
                        isNavigating = true
                    }) {
                        Text("作業開始")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.appPrimary)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                
                // タイトル表示
                .navigationTitle("🚚出荷開始")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation {
                                menuState.isMenuOpen.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .imageScale(.large)
                        }
                    }
                }
                //　画面遷移
                .navigationDestination(isPresented: $isNavigating) {
                    ShippingListView(selectedDate: selectedDate, customerCode: customerCode)
                        .environmentObject(userSession)
                }
            }
        }
    }
}
