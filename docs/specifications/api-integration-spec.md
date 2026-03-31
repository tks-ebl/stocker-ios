# COMPACT STOCKER API連携仕様

## 1. 前提

- 最終的に Azure 上の DB と Web API を利用する
- iOS アプリは DB に直接接続せず、必ず Web API 経由でアクセスする
- API 実装は `StockerWebAPI` 配下の ASP.NET Core Web API とする
- ローカル開発は `Docker Compose` による `API + PostgreSQL` 構成とする
- Azure 本番は `API(Container Apps / App Service for Containers)` と `Azure Database for PostgreSQL Flexible Server` を基本方針とする
- カスタマイズ要件として、同一 LAN 上の PC で動作する Web API に接続できる構成を許容する
- ローカル LAN 接続時も、iOS アプリの機能と API 契約は Azure 運用時と同一とする

## 1.1 接続先モード

- 開発用
  - ローカル URL を利用する
  - 開発者が Docker / ローカル Web API に接続して動作確認するためのモード
- 公開用
  - Azure URL を利用する
  - App Store 公開版の固定接続先とする
- カスタマイズ用
  - 画面で URL を手入力する
  - 顧客環境や社内サーバー接続のためのモードとする

補足:

- 開発時は上記 3 モードを切り替えて確認できるようにする
- 公開版ビルドでは公開用のみを利用し、切替 UI への導線は持たせない
- 現在の iOS 実装では、`Debug = development`、`Release = public` をビルド設定で切り替える
- カスタマイズ用は `STOCKERConnectionMode = customize` を設定したビルド構成で扱う

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
  - JWT アクセストークンの返却

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

### 3.8 ヘルスチェック

- `GET /health`
- 役割
  - API の稼働確認
  - Docker / Azure の疎通確認

## 4. クライアント側方針

- `warehouseId` を API アクセスの基本条件とする
- 画面表示用 ViewModel は API レスポンスを UI モデルへ変換する
- 通信失敗時は再試行可能なエラーメッセージを出す
- 開発時は API ベース URL を切り替え可能にする
- 公開版ビルドでは Azure URL を固定利用とする
- カスタマイズ版では画面から URL 手入力を許可する
- 各モードの違いは接続先のみとする

## 5. セキュリティ方針

- HTTPS を利用する
- アクセストークンを用いた認証を前提とする
- トークンは安全な保存方法を検討する
- Azure 公開時は接続文字列と JWT シークレットを環境変数または Key Vault で管理する
- ローカル LAN 接続でも HTTPS を必須とする
- ATS の包括例外や恒久的な HTTP 許可は採用しない
- ローカル LAN 接続を行う場合は `NSLocalNetworkUsageDescription` を設定する

## 5.1 ローカル LAN モード追加方針

- ローカル LAN モードでは、LAN 上の PC に配置した Web API へ接続する
- 接続先は設定値として保持し、固定的に埋め込まない
- 可能であればホスト名ベースで接続し、証明書の検証ができるようにする
- ローカル LAN モード専用の API やレスポンス形式は定義しない

## 5.2 現在の Web API 実装状況

- `StockerWebAPI` では JWT Bearer 認証を実装済み
- Swagger / OpenAPI を有効化している
- 例外時は `ProblemDetails` ベースで返却する
- 出荷実績登録時は以下をサーバー側で検証する
  - 重複行
  - 在庫不足
  - 出荷計画の倉庫不一致
  - 出荷先コード不一致
  - 計画数量超過
- ローカル起動時は Docker テストで以下を確認できる
  - `GET /health`
  - `POST /auth/login`
  - 認証付き `GET /warehouses/{warehouseId}/inventory`
  - `POST /warehouses/{warehouseId}/shipping-results`

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
- ローカル証明書配布方法
- 開発用 / 公開用 / カスタマイズ用の切替をビルド設定、設定値、フラグのどこで制御するか

補足:

- 接続先切替 UI はアプリ内画面として保持する
- Azure デモ制限は初期版から有効化する方針を採用済み
- ローカル LAN モードはカスタマイズ版で扱う方針を採用済み
- ただし公開版では Azure URL のみを利用し、接続先切替 UI への導線は持たせない

## 8. 初期実装方針

- API は ASP.NET Core 8 の Controller ベースで構成する
- ORM は Entity Framework Core + PostgreSQL を利用する
- 開発段階ではデモシードデータを投入し、iOS 接続確認を優先する
- スキーマ管理は EF Core Migration ベースとする
- Docker テスト用設定と Azure 配置用設定は分離して管理する

## 9. 関連仕様

- 接続設定 UI は `admin-connection-setting-spec.md` を参照する
- Azure デモ制限レスポンスは `demo-limit-api-spec.md` を参照する
- 現在の実装ギャップは `implementation-gap-notes.md` を参照する
