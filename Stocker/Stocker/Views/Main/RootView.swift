import SwiftUI

struct RootView: View {
    @EnvironmentObject var menuState: MenuState
    @EnvironmentObject var userSession: UserSession

    var body: some View {
        if userSession.isLoggedIn {
            MainScreenView()
                .environmentObject(menuState)
                .environmentObject(userSession)
        } else {
            LoginView()
                .environmentObject(menuState)
                .environmentObject(userSession)
        }
    }
}
