# Stocker Web API

`StockerWebAPI` は、`Stocker` iOS アプリ向けのバックエンド API です。

Azure 本番運用を前提にしつつ、ローカルでは `Docker Compose` で `API + PostgreSQL` を起動できる構成にしています。

将来的には、Azure 接続に加えて、同一 LAN 上の PC で稼働する Web API を iOS アプリの接続先として利用できるようにする想定です。

## Tech Stack

- ASP.NET Core 8 Web API
- Entity Framework Core
- PostgreSQL
- JWT Bearer Authentication
- Swagger / OpenAPI
- Docker Compose

## Directory

- `src/StockerWebAPI.Api`
  - API 本体
- `tests/StockerWebAPI.Api.Tests`
  - ユニットテスト用プロジェクト

## Local Run

1. `StockerWebAPI/.env.example` を参考に、必要なら `StockerWebAPI/.env` を作成する
2. `StockerWebAPI` ディレクトリで `docker compose up --build` を実行する
3. API は `http://localhost:8080` で起動する
4. Swagger UI は `http://localhost:8080/swagger` で確認できる

初回起動時は PostgreSQL にデモデータを投入します。

停止:

- `docker compose down`

## Docker Test

Docker だけで確認したい場合は、以下のどちらかを使います。

- 一括実行
  - `./scripts/run-docker-tests.sh`
- 個別実行
  - `docker compose --profile test run --rm unit-tests`
  - `docker compose up -d --build postgres api`
  - `docker compose --profile test run --rm smoke-tests`

`smoke-tests` は以下を確認します。

- `GET /health`
- `POST /auth/login`
- JWT を使った `GET /warehouses/{warehouseId}/inventory`
- `POST /warehouses/{warehouseId}/shipping-results`

## Migration

- 起動時は `Database.Migrate()` により未適用 Migration を反映します
- 追加 Migration は `./scripts/add-migration.sh <MigrationName>` で作成できます
- 以前の `EnsureCreated` 時代のローカル volume を使っている場合は、必要に応じて `docker compose down -v` で作り直してください

## Demo Login

- User Code: `worker01`
- Password: `Passw0rd!`

または

- User Code: `leader01`
- Password: `Passw0rd!`

## Main Endpoints

- `POST /auth/login`
- `GET /warehouses/{warehouseId}/dashboard`
- `GET /warehouses/{warehouseId}/inventory`
- `GET /warehouses/{warehouseId}/inventory/{itemId}/history`
- `GET /warehouses/{warehouseId}/shipping-plans`
- `GET /warehouses/{warehouseId}/shipping-results`
- `POST /warehouses/{warehouseId}/shipping-results`
- `GET /health`

## Azure Deployment Direction

本番は以下の組み合わせを想定しています。

- API: Azure Container Apps または Azure App Service for Containers
- DB: Azure Database for PostgreSQL Flexible Server

アプリ側は接続文字列と JWT シークレットを Azure の環境変数または Key Vault 経由で設定してください。

## Local LAN Deployment Direction

App Store 配布を考慮し、LAN 上の PC を接続先とする場合も HTTPS 前提で運用します。

- Web API は LAN 内から到達可能なホスト名またはアドレスで待ち受ける
- `http://` 常用を前提にしない
- サーバ証明書を設定し、iOS 側で証明書検証が通るようにする
- Azure とローカル LAN で API 契約を変えない
- ローカル運用でも JWT 認証と倉庫単位制御を維持する

補足:

- `docker compose up` の既定起動はローカル開発用途の `http://localhost:8080` です
- iOS 実機から LAN 接続確認を行う構成は、別途 HTTPS 化した起動手順を用意して切り分けます

## iOS App Side Requirements for LAN Mode

LAN モードで iOS 実機接続する場合、アプリ側では以下が必要です。

- API ベース URL の切り替え機能
- `NSLocalNetworkUsageDescription` の設定
- 必要な場合のみ Bonjour 関連設定
- 接続先変更時の再ログイン制御
- LAN 接続失敗時のエラー案内

## Notes

- スキーマ管理は EF Core Migration ベースです
- デモ用シードデータを含むため、機密データは投入しないでください
