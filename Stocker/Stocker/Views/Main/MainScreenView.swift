import SwiftUI

struct MainScreenView: View {
    @EnvironmentObject var menuState: MenuState

    var body: some View {
        ZStack(alignment: .leading) {
            NavigationStack {
                Group {
                    switch menuState.currentSelection {
                    case .home:
                        MainContentView()
                    case .shippingWork:
                        ShippingStartView()
                    case .shippingResult:
                        ShippingResultSearchView()
                    case .inventoryList:
                        InventoryListView()
                    }
                }
                .disabled(menuState.isMenuOpen)
                .blur(radius: menuState.isMenuOpen ? 5 : 0)
                .animation(.easeInOut, value: menuState.isMenuOpen)
            }

            if menuState.isMenuOpen {
                // メニューを前面に表示（zIndexを活用）
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            menuState.isMenuOpen = false
                        }
                    }

                SideMenuView()
                    .frame(width: 240)
                    .background(Color.white)
                    .shadow(radius: 4)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }
        }
    }
}
