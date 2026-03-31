import SwiftUI
import UIKit

struct InventoryListView: View {
    @EnvironmentObject var menuState: MenuState
    @EnvironmentObject var userSession: UserSession
    @StateObject private var viewModel = InventoryViewModel()
    
    @State private var selectedItem: InventoryItem?
    @State private var showPreview: Bool = false
    @State private var isNavigating: Bool = false
    
    var inventoryItems: [InventoryItem] {
        if userSession.usesWebAPI {
            return viewModel.items
        }

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

                VStack(spacing: 16) {
                    if let warehouse = userSession.currentWarehouse, let user = userSession.currentUser {
                        WarehouseContextView(
                            warehouseName: warehouse.name,
                            userName: user.userName,
                            userCode: user.userCode
                        )
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }

                    if let errorMessage = viewModel.errorMessage, userSession.usesWebAPI {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    if viewModel.isLoading && userSession.usesWebAPI {
                        ProgressView("Web API から在庫一覧を取得しています")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    } else if inventoryItems.isEmpty {
                        ContentUnavailableView(
                            "在庫データがありません",
                            systemImage: "cube.transparent",
                            description: Text("この倉庫に表示できる在庫データがありません。")
                        )
                    } else {
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
                                        let feedback = UIImpactFeedbackGenerator(style: .light)
                                        feedback.impactOccurred()
                                    }
                                    .onEnded { success in
                                        if success {
                                            let feedback2 = UIImpactFeedbackGenerator(style: .medium)
                                            feedback2.impactOccurred()

                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                                selectedItem = item
                                                showPreview = true
                                            }
                                        }
                                    }
                            )
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                    }
                }
                
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
                        .environmentObject(userSession)
                }
            }
            .task(id: "\(userSession.currentWarehouse?.apiWarehouseId ?? "")-\(userSession.dataRefreshKey)") {
                await viewModel.loadIfNeeded(userSession: userSession)
            }
        }
    }
}
