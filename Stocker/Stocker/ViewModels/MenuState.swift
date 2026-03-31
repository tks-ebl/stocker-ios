import SwiftUI

// メニューで選択できる画面の種類
enum MenuSelection {
    case home
    case shippingWork
    case shippingResult
    case inventoryList
    case connectionSettings
}

// メニューの状態を管理するクラス
class MenuState: ObservableObject {
    @Published var isMenuOpen: Bool = false                  // メニューが開いているかどうか
    @Published var currentSelection: MenuSelection = .home   // 現在の画面

    func navigate(to selection: MenuSelection) {
        let wasMenuOpen = isMenuOpen

        withAnimation {
            isMenuOpen = false
        }

        if wasMenuOpen {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.currentSelection = selection
            }
        } else {
            currentSelection = selection
        }
    }
}
