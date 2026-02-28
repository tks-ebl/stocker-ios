import SwiftUI

struct IsLoggedInKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isLoggedIn: Binding<Bool> {
        get { self[IsLoggedInKey.self] }
        set { self[IsLoggedInKey.self] = newValue }
    }
}
