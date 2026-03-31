import SwiftUI

struct ConnectionSettingsView: View {
    @EnvironmentObject var menuState: MenuState
    @EnvironmentObject var userSession: UserSession

    @State private var apiBaseURL = AppConnectionSettings.apiBaseURLString
    @State private var statusMessage: String?
    @State private var isError = false
    @State private var isChecking = false
    @State private var isSaving = false

    var body: some View {
        NavigationStack {
            Form {
                Section("現在の設定") {
                    Text("保存済み URL")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(AppConnectionSettings.apiBaseURLString.isEmpty ? "未設定" : AppConnectionSettings.apiBaseURLString)
                        .font(.body.monospaced())
                }

                Section("接続先 URL") {
                    TextField("http://localhost:8080", text: $apiBaseURL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .keyboardType(.URL)

                    Text("例: `http://localhost:8080` または `https://192.168.1.10:8080`")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Section("操作") {
                    Button {
                        checkConnection()
                    } label: {
                        HStack {
                            if isChecking {
                                ProgressView()
                            }
                            Text("接続確認")
                        }
                    }
                    .disabled(isChecking || isSaving)

                    Button {
                        saveSettings()
                    } label: {
                        HStack {
                            if isSaving {
                                ProgressView()
                            }
                            Text("保存")
                        }
                    }
                    .disabled(isChecking || isSaving)

                    Button("既定値へ戻す") {
                        apiBaseURL = "http://localhost:8080"
                        statusMessage = nil
                    }
                    .disabled(isChecking || isSaving)
                }

                if let statusMessage {
                    Section("結果") {
                        Text(statusMessage)
                            .foregroundColor(isError ? .red : .primary)
                    }
                }
            }
            .navigationTitle("接続設定")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            menuState.isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .imageScale(.large)
                    }
                }
            }
        }
    }

    private func checkConnection() {
        isChecking = true
        statusMessage = nil
        isError = false

        Task {
            do {
                try await APIClient.shared.checkHealth(baseURLString: apiBaseURL)
                await MainActor.run {
                    isChecking = false
                    isError = false
                    statusMessage = "接続確認に成功しました。"
                }
            } catch {
                await MainActor.run {
                    isChecking = false
                    isError = true
                    statusMessage = error.localizedDescription
                }
            }
        }
    }

    private func saveSettings() {
        isSaving = true
        statusMessage = nil
        isError = false

        Task {
            let normalized = AppConnectionSettings.normalizedURL(from: apiBaseURL)

            await MainActor.run {
                guard normalized != nil else {
                    isSaving = false
                    isError = true
                    statusMessage = "接続先 URL の形式が不正です。"
                    return
                }

                AppConnectionSettings.save(apiBaseURLString: apiBaseURL)
                isSaving = false
                isError = false

                if userSession.usesWebAPI {
                    userSession.logout()
                    statusMessage = "保存しました。接続先変更のため再ログインしてください。"
                } else {
                    statusMessage = "接続設定を保存しました。"
                }
            }
        }
    }
}
