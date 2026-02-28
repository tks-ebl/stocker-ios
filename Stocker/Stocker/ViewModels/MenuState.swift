import SwiftUI

// メニューで選択できる画面の種類
enum MenuSelection {
    case home
    case shippingWork
    case shippingResult
    case inventoryList
}

// メニューの状態を管理するクラス
class MenuState: ObservableObject {
    @Published var isMenuOpen: Bool = false                  // メニューが開いているかどうか
    @Published var currentSelection: MenuSelection = .home   // 現在の画面
}
