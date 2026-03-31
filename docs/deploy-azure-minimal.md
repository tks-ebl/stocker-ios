# Azure Minimal Deployment

このドキュメントは、`StockerWebAPI` を Azure に最小構成で配置するための手順メモです。

今回は次の前提で整理しています。

- デモ用途
- 一人運用
- 可用性よりコスト優先
- 秘密情報は Azure 側の Secret / 環境変数で管理
- ログはエラー中心

## Important

現時点の `StockerWebAPI` は `PostgreSQL` 前提で実装されています。

- `Program.cs` で `UseNpgsql(...)` を使用
- EF Core Provider が `Npgsql.EntityFrameworkCore.PostgreSQL`
- Migration も PostgreSQL 向け

そのため、このドキュメントでも Azure 側の DB は `Azure Database for PostgreSQL Flexible Server` を前提にします。

## Azure で作るもの

| 種別 | 例 | 用途 |
|---|---|---|
| Resource Group | `stocker-demo-rg` | 関連リソースの入れ物 |
| Container Apps Environment または App Service Plan | `stocker-demo-env` / `stocker-demo-plan` | API 実行基盤 |
| Container App または App Service | `stocker-demo-api` | API 公開先 |
| PostgreSQL Flexible Server | `stocker-demo-pg` | アプリ用 DB |
| Application Insights | `stocker-demo-ai` | エラー確認 |
| Budget | `stocker-demo-budget` | 予算通知 |

## 作成手順

### 1. Resource Group を作る

Azure Portal で `Resource groups` を開き、`Create` を選択します。

- Name: `stocker-demo-rg`
- Region: `Japan East`

## 2. Azure Database for PostgreSQL Flexible Server を作る

`Azure Database for PostgreSQL flexible servers` から `Create` を選択します。

推奨の開始値:

- Server name: `stocker-demo-pg`
- Workload type: `Development`
- Compute tier: 小さい構成から開始
- High availability: 無効で開始
- Public access または Private access は運用方針に合わせて選択

補足:

- PostgreSQL Flexible Server を本番 DB 候補とする
- SSL 必須の接続文字列を使う

参考:

- [Quickstart: Create an Azure Database for PostgreSQL flexible server](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/quickstart-create-server-portal)

### 3. PostgreSQL の接続制御を設定する

PostgreSQL Flexible Server の `Networking` で、必要な接続元だけを許可します。

最小構成では以下を確認します。

- 自分の作業端末から接続できる
- Container Apps または App Service からの接続方針を決める

参考:

- [Networking concepts for Azure Database for PostgreSQL flexible server](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-networking-private)

### 4. Container Apps または App Service を作る

`Container Apps` または `App Services` から `Create` を選択します。

設定の考え方:

- Docker イメージを使う
- Region: `Japan East`
- 小さい構成から開始
- `/health` をヘルスチェックに使う

参考:

- [Quickstart: Deploy your first container app using the Azure portal](https://learn.microsoft.com/en-us/azure/container-apps/quickstart-portal)
- [Quickstart: Create an App Service app](https://learn.microsoft.com/en-us/azure/app-service/quickstart-custom-container)

### 5. Azure の環境変数を入れる

Container Apps または App Service に環境変数を設定します。

最低限必要な候補:

- `ConnectionStrings__Default`
- `Jwt__Issuer`
- `Jwt__Audience`
- `Jwt__SigningKey`
- `ASPNETCORE_ENVIRONMENT`
- `ASPNETCORE_HTTP_PORTS`

### 6. API をデプロイする

初回は `StockerWebAPI/deploy/azure/scripts/` のスクリプト雛形を使ってもよいです。

公開後に確認する項目:

- `GET /health` が `200` を返す
- 認証 API が動く
- DB 接続エラーが出ていない

### 7. エラーログと予算を設定する

最初は取りすぎない方針にします。

- 例外
- 重大エラー
- 起動失敗

予算は `Cost Management + Billing` で月額 10,000 円を基準に設定します。

参考:

- [Create and manage Azure budgets](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-acm-create-budgets)

## リリース前チェック

- Azure 上のリソース名を記録した
- API 公開 URL を確認した
- 環境変数を Azure に設定した
- `Jwt__SigningKey` を開発用のまま使っていない
- DB 接続を確認した
- `GET /health` を確認した
- 予算アラートを設定した
- エラーログの見方を確認した

## Current Gap

現在の実装では、Azure 配置用の雛形と Docker テストはあるものの、実環境へのデプロイ検証はまだです。

- ACR / Container Apps / App Service の実リソース作成
- PostgreSQL Flexible Server との接続確認
- Secret 管理の確定
- 監視設定の実運用化
