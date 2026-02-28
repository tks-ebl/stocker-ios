import SwiftUI

struct ShippingResultSearchView: View {
    @EnvironmentObject var menuState: MenuState
    @State private var selectedDate: Date = Date()
    @State private var userCode: String = ""
    @State private var isNavigating = false

    var body: some View {
        ZStack(alignment: .leading) {
            NavigationStack {
                VStack(alignment: .leading, spacing: 24) {

                    // 日付入力
                    VStack(alignment: .leading) {
                        Text("日付")
                            .font(.headline)
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                    }
                    .padding(.horizontal)

                    // ユーザーコード入力
                    VStack(alignment: .leading) {
                        Text("ユーザーCD")
                            .font(.headline)
                        TextField("ユーザーコードを入力", text: $userCode)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.horizontal)

                    Spacer()

                    // 検索ボタン
                    Button(action: {
                        isNavigating = true
                    }) {
                        Text("検索")
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
                .disabled(menuState.isMenuOpen)
                .blur(radius: menuState.isMenuOpen ? 5 : 0)
                
                // タイトル表示
                .navigationTitle("🚚 出荷検索")
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
                    ShippingResultListView(date: selectedDate, userCode: userCode)
                }
            }
        }
        .animation(.easeInOut, value: menuState.isMenuOpen)
    }
}
