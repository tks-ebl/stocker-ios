# Azure Minimal Deployment

このドキュメントは、`StockerWebAPI` を Azure に最小構成で配置するための手順メモです。

今回は次の前提で整理しています。

- デモ用途
- 一人運用
- 可用性よりコスト優先
- 秘密情報は `App Service` のアプリ設定で管理
- ログはエラー中心

## Important

現時点の `StockerWebAPI` は `PostgreSQL` 前提で実装されています。

- `Program.cs` で `UseNpgsql(...)` を使用
- EF Core Provider が `Npgsql.EntityFrameworkCore.PostgreSQL`
- Migration も PostgreSQL 向け

そのため、`Azure SQL Database Serverless` を使うには、別途アプリ側の DB 対応変更が必要です。

このドキュメントでは、次の2段階で進める前提にします。

1. まず Azure 配置に必要な運用情報を整備する
2. Azure SQL へ切り替える場合は、DB プロバイダー変更を別タスクで実施する

## Azure で作るもの

| 種別 | 例 | 用途 |
|---|---|---|
| Resource Group | `stocker-demo-rg` | 関連リソースの入れ物 |
| App Service Plan | `stocker-demo-plan` | API 実行基盤 |
| App Service | `stocker-demo-api` | API 公開先 |
| SQL logical server | `stocker-demo-sqlsvr` | Azure SQL の親サーバー |
| Azure SQL Database | `stocker-demo-db` | アプリ用 DB |
| Application Insights | `stocker-demo-ai` | エラー確認 |
| Budget | `stocker-demo-budget` | 予算通知 |

## 作成手順

### 1. Resource Group を作る

Azure Portal で `Resource groups` を開き、`Create` を選択します。

- Name: `stocker-demo-rg`
- Region: `Japan East`

## 2. Azure SQL Database Serverless を作る

`SQL databases` から `Create` を選択します。

推奨の開始値:

- Database name: `stocker-demo-db`
- Server: 新規作成
- Compute tier: `Serverless`
- Service tier: `General Purpose`
- Auto-pause: 有効
- 最小構成で開始

補足:

- Azure SQL Serverless は、アイドル時に compute 課金を抑えやすい構成です
- 最初の接続時に再開待ちが発生することがあります

参考:

- [Create a single database in Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/single-database-create-quickstart)
- [Serverless compute tier for Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/serverless-tier-overview)

### 3. SQL の接続制御を設定する

SQL Server の `Networking` で、必要な接続元だけを許可します。

最小構成では以下を確認します。

- 自分の作業端末から接続できる
- App Service からの接続方針を決める

参考:

- [Network access controls for Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/network-access-controls-overview)

### 4. App Service を作る

`App Services` から `Create` を選択します。

設定の考え方:

- Publish: `Code`
- Runtime stack: API 実装に合わせる
- Region: `Japan East`
- Pricing plan: 小さいプランから開始

参考:

- [Quickstart: Create an App Service app in the Azure portal](https://learn.microsoft.com/en-us/azure/app-service/quickstart-html)

### 5. App Service のアプリ設定を入れる

`Settings > Environment variables` に設定します。

最低限必要な候補:

- `ConnectionStrings__Default`
- `Jwt__Issuer`
- `Jwt__Audience`
- `Jwt__SigningKey`
- `ASPNETCORE_ENVIRONMENT`

参考:

- [Configure an App Service app in the Azure portal](https://learn.microsoft.com/en-us/azure/app-service/configure-common)

### 6. API をデプロイする

初回は手動でもよいですが、継続運用を考えると GitHub Actions に寄せるのが楽です。

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
- App Service の URL を確認した
- 環境変数を Azure に設定した
- `Jwt__SigningKey` を開発用のまま使っていない
- DB 接続を確認した
- `GET /health` を確認した
- 予算アラートを設定した
- エラーログの見方を確認した

## Current Gap

現在の実装では、Azure 本番 DB 候補とアプリ実装に差分があります。

- 希望: `Azure SQL Database Serverless`
- 現状: `PostgreSQL`

Azure SQL へ切り替えるには、少なくとも以下が必要です。

- EF Core Provider を SQL Server 用へ変更
- `UseNpgsql` を `UseSqlServer` へ変更
- Migration の作り直しまたは移行方針の整理
- SQL 方言差分の確認

この差分対応は、Azure リソース作成とは別タスクで扱うのが安全です。
