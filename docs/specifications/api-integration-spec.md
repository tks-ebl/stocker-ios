# COMPACT STOCKER API連携仕様

## 1. 前提

- 最終的に Azure 上の DB と Web API を利用する
- iOS アプリは DB に直接接続せず、必ず Web API 経由でアクセスする

## 2. API 連携の目的

- ログイン認証
- 所属倉庫の確定
- 在庫一覧取得
- 在庫履歴取得
- 出荷予定取得
- 出荷実績登録
- 出荷実績検索

## 3. 想定 API 一覧

### 3.1 認証

- `POST /auth/login`
- 役割
  - ログイン認証
  - ユーザー情報と所属倉庫情報の返却

### 3.2 ホーム情報

- `GET /warehouses/{warehouseId}/dashboard`
- 役割
  - 出荷予定件数
  - 出荷実績件数
  - 棚卸情報などの返却

### 3.3 在庫一覧

- `GET /warehouses/{warehouseId}/inventory`
- 役割
  - 在庫一覧の返却

### 3.4 在庫履歴

- `GET /warehouses/{warehouseId}/inventory/{itemId}/history`
- 役割
  - 商品別履歴の返却

### 3.5 出荷予定

- `GET /warehouses/{warehouseId}/shipping-plans`
- 役割
  - 日付や出荷先コードで絞り込んだ出荷予定の返却

### 3.6 出荷実績登録

- `POST /warehouses/{warehouseId}/shipping-results`
- 役割
  - 出荷実績の保存

### 3.7 出荷実績検索

- `GET /warehouses/{warehouseId}/shipping-results`
- 役割
  - 日付やユーザーコードで絞り込んだ実績の返却

## 4. クライアント側方針

- `warehouseId` を API アクセスの基本条件とする
- 画面表示用 ViewModel は API レスポンスを UI モデルへ変換する
- 通信失敗時は再試行可能なエラーメッセージを出す

## 5. セキュリティ方針

- HTTPS を利用する
- アクセストークンを用いた認証を前提とする
- トークンは安全な保存方法を検討する

## 6. 実装段階の分離

- Phase 1
  - 現行のサンプルデータで UI を完成させる
- Phase 2
  - API クライアント層を追加する
- Phase 3
  - サンプルデータを API 連携へ置き換える

## 7. 未確定事項

- 認証方式の詳細
- API のレスポンス形式
- オフライン時のキャッシュ戦略
- データ更新競合時の扱い
