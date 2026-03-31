import SwiftUI
import SwiftData

@main
struct StockerApp: App {
    @StateObject var menuState = MenuState()
    @StateObject var userSession = UserSession()

    init() {
        AppConnectionSettings.registerDefaults()
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Item.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(menuState)
                .environmentObject(userSession)
        }
        .modelContainer(sharedModelContainer)
    }
}
