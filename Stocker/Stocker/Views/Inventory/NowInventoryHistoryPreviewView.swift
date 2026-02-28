import SwiftUI

struct NowInventoryHistoryPreviewView: View {
    let item: InventoryItem
    let onTapDetail: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // ヘッダー部
            HStack {
                Image(systemName: "cube.box.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.blue)

                VStack(alignment: .leading) {
                    Text(item.itemName)
                        .font(.title2.bold())
                        .foregroundColor(.primary)

                    Text("コード: \(item.itemCode)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }

            Divider()

            // ロケーション & 数量
            HStack(spacing: 12) {
                Label("ロケーション", systemImage: "location")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Text(item.location)
                    .font(.body)
                    .foregroundColor(.primary)
            }

            HStack(spacing: 12) {
                Label("数量", systemImage: "number.circle")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Text("\(item.quantity) 個")
                    .font(.body)
                    .foregroundColor(.primary)
            }

            Divider()

            // ボタン
            Button {
                onTapDetail()
            } label: {
                HStack {
                    Image(systemName: "arrow.forward.circle.fill")
                    Text("詳細を表示")
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
    }
}
