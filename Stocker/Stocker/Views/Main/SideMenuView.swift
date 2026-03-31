import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var menuState: MenuState
    @EnvironmentObject var userSession: UserSession

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // ロゴ部：ここをタップするとホームに戻る
            HStack {
                Image(systemName: "shippingbox.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.appPrimary)

                Text("STOCKER")
                    .font(.title3.bold())
                    .foregroundColor(.appPrimary)
            }
            .padding(.top, 80)
            .padding(.horizontal)
            .onTapGesture {
                menuState.navigate(to: .home)
            }

            Divider()

            // メニューリスト
            VStack(alignment: .leading, spacing: 16) {
                MenuItemView(title: "出荷作業", systemImage: "box.truck.fill",
                    isSelected: menuState.currentSelection == .shippingWork) {
                    menuState.navigate(to: .shippingWork)
                }
                MenuItemView(title: "出荷実績", systemImage: "checkmark.seal",
                             isSelected: menuState.currentSelection == .shippingResult) {
                    menuState.navigate(to: .shippingResult)
                }
                MenuItemView(title: "在庫一覧", systemImage: "cube.box",
                             isSelected: menuState.currentSelection == .inventoryList) {
                    menuState.navigate(to: .inventoryList)
                }
            }
            .padding(.horizontal)

            Spacer()
            
            Divider()
                .padding(.horizontal)

            // ログアウトやバージョン情報など
            VStack(alignment: .leading, spacing: 12) {
                if let warehouse = userSession.currentWarehouse, let user = userSession.currentUser {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(warehouse.name)
                            .font(.headline)
                        Text("担当者: \(user.userName)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("ユーザーCD: \(user.userCode)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 8)
                }

                Button(action: {
                    userSession.logout()
                    menuState.isMenuOpen = false
                }) {
                    HStack(spacing: 16) {
                        Image(systemName: "arrowshape.turn.up.left")
                            .font(.system(size: 20))
                            .frame(width: 28, height: 28)
                            .foregroundColor(.red)

                        Text("ログアウト")
                            .font(.body)
                            .foregroundColor(.red)

                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())

                Text("Ver. 1.0.0")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.leading, 40)
            }
            .padding(.bottom, 30)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: 240)
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.all)
    }
}
