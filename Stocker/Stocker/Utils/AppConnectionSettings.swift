import Foundation

enum AppConnectionSettings {
    private static let customAPIBaseURLKey = "custom_api_base_url"

    static func registerDefaults() {
        UserDefaults.standard.register(defaults: [
            customAPIBaseURLKey: AppBuildSettings.shared.defaultAPIBaseURL
        ])
    }

    static var apiBaseURLString: String {
        switch AppBuildSettings.shared.connectionMode {
        case .development:
            return AppBuildSettings.shared.developmentAPIBaseURL
        case .publicRelease:
            return AppBuildSettings.shared.publicAPIBaseURL
        case .customize:
            let savedValue = UserDefaults.standard.string(forKey: customAPIBaseURLKey) ?? ""
            let trimmedValue = savedValue.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmedValue.isEmpty ? AppBuildSettings.shared.defaultAPIBaseURL : trimmedValue
        }
    }

    static var apiBaseURL: URL? {
        normalizedURL(from: apiBaseURLString)
    }

    static func save(apiBaseURLString: String) {
        guard AppBuildSettings.shared.allowsCustomURLInput else {
            return
        }

        UserDefaults.standard.set(apiBaseURLString.trimmingCharacters(in: .whitespacesAndNewlines), forKey: customAPIBaseURLKey)
    }

    static func resetToDefault() {
        guard AppBuildSettings.shared.allowsCustomURLInput else {
            return
        }

        UserDefaults.standard.set(AppBuildSettings.shared.defaultAPIBaseURL, forKey: customAPIBaseURLKey)
    }

    static func normalizedURL(from rawValue: String) -> URL? {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return nil
        }

        return URL(string: trimmed)
    }
}
