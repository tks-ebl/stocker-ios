import SwiftUI

struct MainContentView: View {
    @EnvironmentObject var menuState: MenuState

    // 仮の日付データ
    let lastInventoryDate = Date(timeIntervalSinceNow: -86400 * 30) // 30日前
    let nextInventoryDate = Date(timeIntervalSinceNow: 86400 * 60)  // 60日後
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // ヘッダー（≡ ボタンあり）
            MenuHeaderView(title: "STOCKER")

            Text("本日の状況")
                .font(.title.bold())
                .padding(.horizontal)

            VStack(spacing: 16) {
                InfoCardView(title: "出荷予定", value: 12, color: .blue)
                InfoCardView(title: "出荷実績", value: 9, color: .green)
                InfoCardView(title: "入荷予定", value: 7, color: .purple)
                InfoCardView(title: "入荷実績", value: 5, color: .indigo)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("棚卸日")
                        .font(.headline)
                        .foregroundColor(.gray)

                    HStack {
                        Spacer()
                        Text("前回: \(formattedDate(lastInventoryDate))")
                            .font(.body)
                    }

                    HStack {
                        Spacer()
                        Text("次回: \(formattedDate(nextInventoryDate))")
                            .font(.body)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 1)

            }
            .padding(.horizontal)

            Spacer()
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月d日"
        return formatter.string(from: date)
    }
}
