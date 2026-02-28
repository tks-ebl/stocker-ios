import Foundation

class TokenManager {
    private static let key = "AuthToken"
    
    static func save(token: String) {
        UserDefaults.standard.set(token, forKey: key)
    }

    static func load() -> String? {
        UserDefaults.standard.string(forKey: key)
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
