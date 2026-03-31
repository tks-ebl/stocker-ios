import Foundation

enum AppConnectionMode: String {
    case development
    case publicRelease = "public"
    case customize
}

struct AppBuildSettings {
    static let shared = AppBuildSettings()

    let connectionMode: AppConnectionMode
    let developmentAPIBaseURL: String
    let publicAPIBaseURL: String

    private init(bundle: Bundle = .main) {
        let rawMode = bundle.stringValue(forInfoDictionaryKey: "STOCKERConnectionMode")
        connectionMode = AppConnectionMode(rawValue: rawMode) ?? .development
        developmentAPIBaseURL = bundle.stringValue(forInfoDictionaryKey: "STOCKERDevelopmentAPIBaseURL")
        publicAPIBaseURL = bundle.stringValue(forInfoDictionaryKey: "STOCKERPublicAPIBaseURL")
    }

    var connectionModeLabel: String {
        switch connectionMode {
        case .development:
            return "開発用"
        case .publicRelease:
            return "公開用"
        case .customize:
            return "カスタマイズ用"
        }
    }

    var defaultAPIBaseURL: String {
        switch connectionMode {
        case .development:
            return developmentAPIBaseURL
        case .publicRelease:
            return publicAPIBaseURL
        case .customize:
            return publicAPIBaseURL
        }
    }

    var allowsCustomURLInput: Bool {
        connectionMode == .customize
    }
}

private extension Bundle {
    func stringValue(forInfoDictionaryKey key: String) -> String {
        (object(forInfoDictionaryKey: key) as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}
