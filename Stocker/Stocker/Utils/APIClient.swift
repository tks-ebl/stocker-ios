import Foundation

enum APIClientError: LocalizedError {
    case invalidBaseURL
    case invalidResponse
    case unauthorized
    case serverError(String)
    case transportError(String)

    var errorDescription: String? {
        switch self {
        case .invalidBaseURL:
            return "Web API の接続先設定が不正です。"
        case .invalidResponse:
            return "Web API から不正な応答が返されました。"
        case .unauthorized:
            return "ログインに失敗しました。ユーザーIDまたはパスワードを確認してください。"
        case .serverError(let message):
            return message
        case .transportError(let message):
            return "Web API に接続できませんでした。\(message)"
        }
    }
}

final class APIClient {
    static let shared = APIClient()

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(session: URLSession = .shared) {
        self.session = session

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        self.encoder = encoder
    }

    func get<T: Decodable>(
        path: String,
        queryItems: [URLQueryItem] = [],
        bearerToken: String? = nil
    ) async throws -> T {
        var request = try makeRequest(path: path, method: "GET", queryItems: queryItems, bearerToken: bearerToken)
        request.httpBody = nil
        return try await send(request)
    }

    func post<Body: Encodable, T: Decodable>(
        path: String,
        body: Body,
        bearerToken: String? = nil
    ) async throws -> T {
        var request = try makeRequest(path: path, method: "POST", bearerToken: bearerToken)
        request.httpBody = try encoder.encode(body)
        return try await send(request)
    }

    func checkHealth() async throws {
        let request = try makeRequest(path: "/health", method: "GET")
        let (_, response) = try await execute(request)
        guard let httpResponse = response as? HTTPURLResponse, (200 ... 299).contains(httpResponse.statusCode) else {
            throw APIClientError.invalidResponse
        }
    }

    private func makeRequest(
        path: String,
        method: String,
        queryItems: [URLQueryItem] = [],
        bearerToken: String? = nil
    ) throws -> URLRequest {
        guard let baseURL = AppConnectionSettings.apiBaseURL else {
            throw APIClientError.invalidBaseURL
        }

        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw APIClientError.invalidBaseURL
        }

        let basePath = components.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let requestPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        components.path = "/" + [basePath, requestPath].filter { !$0.isEmpty }.joined(separator: "/")
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components.url else {
            throw APIClientError.invalidBaseURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if method != "GET" {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        if let bearerToken, !bearerToken.isEmpty {
            request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    private func send<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await execute(request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIClientError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200 ... 299:
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIClientError.invalidResponse
            }
        case 401:
            throw APIClientError.unauthorized
        default:
            if let problem = try? decoder.decode(APIProblemDetails.self, from: data),
               let detail = problem.detail, !detail.isEmpty {
                throw APIClientError.serverError(detail)
            }

            throw APIClientError.serverError("Web API でエラーが発生しました。(status: \(httpResponse.statusCode))")
        }
    }

    private func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(for: request)
        } catch {
            throw APIClientError.transportError(error.localizedDescription)
        }
    }
}

private struct APIProblemDetails: Decodable {
    let title: String?
    let detail: String?
}
