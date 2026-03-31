import Foundation

enum AppConnectionSettings {
    private static let apiBaseURLKey = "api_base_url"

    static func registerDefaults() {
        UserDefaults.standard.register(defaults: [
            apiBaseURLKey: "http://localhost:8080"
        ])
    }

    static var apiBaseURLString: String {
        (UserDefaults.standard.string(forKey: apiBaseURLKey) ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static var apiBaseURL: URL? {
        let rawValue = apiBaseURLString
        guard !rawValue.isEmpty else {
            return nil
        }

        return URL(string: rawValue)
    }
}
