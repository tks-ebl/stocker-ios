import SwiftUI

struct RootView: View {
    @State private var isLoggedIn = false
    @EnvironmentObject var menuState: MenuState

    var body: some View {
        if isLoggedIn {
            MainScreenView(isLoggedIn: $isLoggedIn)  // ← Bindingで渡す
                .environmentObject(menuState)
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
                .environmentObject(menuState)
        }
    }
}
