import Foundation

enum AppConnectionSettings {
    private static let apiBaseURLKey = "api_base_url"
    private static let defaultAPIBaseURL = "http://localhost:8080"

    static func registerDefaults() {
        UserDefaults.standard.register(defaults: [
            apiBaseURLKey: defaultAPIBaseURL
        ])
    }

    static var apiBaseURLString: String {
        (UserDefaults.standard.string(forKey: apiBaseURLKey) ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static var apiBaseURL: URL? {
        normalizedURL(from: apiBaseURLString)
    }

    static func save(apiBaseURLString: String) {
        UserDefaults.standard.set(apiBaseURLString.trimmingCharacters(in: .whitespacesAndNewlines), forKey: apiBaseURLKey)
    }

    static func resetToDefault() {
        UserDefaults.standard.set(defaultAPIBaseURL, forKey: apiBaseURLKey)
    }

    static func normalizedURL(from rawValue: String) -> URL? {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return nil
        }

        return URL(string: trimmed)
    }
}
