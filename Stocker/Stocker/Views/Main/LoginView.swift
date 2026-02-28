import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool

    @State private var userCd = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var loginError: String?
    @EnvironmentObject var menuState: MenuState

    var body: some View {
        VStack(spacing: 24) {
            
            Spacer()

            Image(systemName: "lock.shield.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.accentColor)
                .padding(.bottom, 10)

            Text("サインイン")
                .font(.largeTitle)
                .bold()

            VStack(alignment: .leading, spacing: 16) {
                TextField("ユーザーID", text: $userCd)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.asciiCapable)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .onChange(of: userCd) { oldValue, newValue in
                        // 英数字以外は除外
                        userCd = newValue.filter { $0.isASCII && $0.isLetter || $0.isNumber }
                    }

                SecureField("パスワード", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.asciiCapable)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .onChange(of: password) { oldValue, newValue in
                        password = newValue.filter { $0.isASCII && $0.isLetter || $0.isNumber }
                    }
            }

            if let loginError = loginError {
                Text(loginError)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Button(action: login) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("ログイン")
                            .bold()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(isLoading || userCd.isEmpty || password.isEmpty)

            Spacer()
        }
        .padding()
        .accentColor(.appPrimary)
    }

    private func login() {
        isLoading = true
        loginError = nil

        // TODO: 本来はAPIなどの認証処理を入れる

        // 成功時は単に状態を切り替える
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoggedIn = true
            isLoading = false
        }
    }
}
