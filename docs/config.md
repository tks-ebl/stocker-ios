# Configuration Reference

`StockerWebAPI` を Azure で動かす際の設定項目一覧です。

現在のアプリは `.NET` の階層設定を使っており、Azure Container Apps / App Service では環境変数として投入します。

## Azure に入れる設定

| 名前 | 必須 | 用途 | 例 |
|---|---|---|---|
| `ConnectionStrings__Default` | 必須 | DB 接続文字列 | PostgreSQL ごとに異なる |
| `Jwt__Issuer` | 必須 | JWT 発行者 | `StockerWebAPI` |
| `Jwt__Audience` | 必須 | JWT 利用対象 | `StockerClients` |
| `Jwt__SigningKey` | 必須 | JWT 署名鍵 | 長くランダムな文字列 |
| `ASPNETCORE_ENVIRONMENT` | 必須 | 実行環境 | `Production` |
| `ASPNETCORE_HTTP_PORTS` | 推奨 | HTTP ポート | `8080` |
| `SEED__ENABLEDEMOSEED` | 推奨 | デモデータ投入可否 | `false` |

## 運用ルール

- 機密情報はコードに書かない
- 共有しやすい値と秘密情報を分けて管理する
- 本番では `SEED__ENABLEDEMOSEED=false` を使う
- `Jwt__SigningKey` は十分長いランダム値にする

## 接続文字列について

現在のアプリ実装は PostgreSQL 形式を前提にしています。

例:

```text
Host=<postgres-flexible-server>.postgres.database.azure.com;Port=5432;Database=stocker;Username=<db-user>;Password=<db-password>;Ssl Mode=Require;Trust Server Certificate=false
```

`StockerWebAPI` の本番 DB 候補は Azure Database for PostgreSQL Flexible Server です。

## 変更時に見る場所

- API 設定読み込み: [Program.cs](/Users/takase/Source/GitHub-Tks/stocker-ios/StockerWebAPI/src/StockerWebAPI.Api/Program.cs)
- Design-time DB 設定: [AppDbContextFactory.cs](/Users/takase/Source/GitHub-Tks/stocker-ios/StockerWebAPI/src/StockerWebAPI.Api/Data/AppDbContextFactory.cs)
- Azure Container Apps 用の設定例: [containerapp.template.yaml](/Users/takase/Source/GitHub-Tks/stocker-ios/StockerWebAPI/deploy/azure/containerapp.template.yaml)
- Azure App Service 用の設定例: [appservice.appsettings.json.example](/Users/takase/Source/GitHub-Tks/stocker-ios/StockerWebAPI/deploy/azure/appservice.appsettings.json.example)
