import SwiftUI
import UIKit

struct InventoryListView: View {
    @EnvironmentObject var menuState: MenuState
    @EnvironmentObject var userSession: UserSession
    
    @State private var selectedItem: InventoryItem?
    @State private var showPreview: Bool = false
    @State private var isNavigating: Bool = false
    
    var inventoryItems: [InventoryItem] {
        guard let warehouseId = userSession.currentWarehouse?.id else {
            return []
        }
        return sampleInventoryItems.filter { $0.warehouseId == warehouseId }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景グラデーション
                LinearGradient(
                    colors: [Color(.systemGroupedBackground), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // 在庫リスト
                List(inventoryItems) { item in
                    HStack(spacing: 12) {
                        Image(systemName: "cube.box.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.appPrimary)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.itemName)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            
                            Text("コード: \(item.itemCode)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Text("ロケーション: \(item.location)")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                        
                        Spacer()
                        
                        Text("\(item.quantity)個")
                            .bold()
                            .foregroundColor(.appPrimary)
                    }
                    .padding(12)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .shadow(color: .gray.opacity(0.15), radius: 4, x: 0, y: 2)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        guard !showPreview else { return }
                        selectedItem = item
                        isNavigating = true
                    }
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.5)
                            .onChanged { _ in
                                // 長押し開始時のバイブ（1回目）
                                let feedback = UIImpactFeedbackGenerator(style: .light)
                                feedback.impactOccurred()
                            }
                            .onEnded { success in
                                if success {
                                    // 0.5秒間押し続けた（成功）
                                    // 2回目のバイブ
                                    let feedback2 = UIImpactFeedbackGenerator(style: .medium)
                                    feedback2.impactOccurred()

                                    // プレビュー表示（アニメーション付き）
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                        selectedItem = item
                                        showPreview = true
                                    }
                                } else {
                                    // 長押しキャンセル（0.5秒未満で離した場合）
                                    // 何もしない or 必要なら処理
                                }
                            }
                    )

                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                
                // プレビューオーバーレイ
                if showPreview, let previewItem = selectedItem {
                    ZStack {
                        // 半透明の黒背景（モーダル風）
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    showPreview = false
                                }
                            }

                        // プレビュービュー本体（中央固定）
//                        InventoryHistoryPreviewView(item: previewItem) {
//                            withAnimation {
//                                showPreview = false
//                            }
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                isNavigating = true
//                            }
//                        }
//                        .frame(maxWidth: 320)
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(24)
//                        .shadow(radius: 12)
//                        .transition(.scale.combined(with: .opacity))
                        NowInventoryHistoryPreviewView(item: previewItem) {
                            withAnimation {
                                showPreview = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                isNavigating = true
                            }
                        }
                        .frame(maxWidth: 360)
                        .padding()
                        .background(Color.clear)
                        .transition(.scale.combined(with: .opacity))
                        .zIndex(1)

                    }
                    .zIndex(1)
                }
            }
            .navigationTitle("📦 在庫一覧")
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
            .navigationDestination(isPresented: $isNavigating) {
                if let item = selectedItem {
                    InventoryHistoryDetailView(item: item)
                }
            }
        }
    }
}
