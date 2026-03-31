# Configuration Reference

`StockerWebAPI` を Azure で動かす際の設定項目一覧です。

現在のアプリは `.NET` の階層設定を使っており、Azure App Service では環境変数として投入します。

## App Service に入れる設定

| 名前 | 必須 | 用途 | 例 |
|---|---|---|---|
| `ConnectionStrings__Default` | 必須 | DB 接続文字列 | DB ごとに異なる |
| `Jwt__Issuer` | 必須 | JWT 発行者 | `StockerWebAPI` |
| `Jwt__Audience` | 必須 | JWT 利用対象 | `StockerClients` |
| `Jwt__SigningKey` | 必須 | JWT 署名鍵 | 長くランダムな文字列 |
| `ASPNETCORE_ENVIRONMENT` | 必須 | 実行環境 | `Production` |
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
Host=postgres;Port=5432;Database=stocker;Username=stocker;Password=your_password
```

一方、Azure SQL Database Serverless を使う場合は SQL Server 形式になります。

例:

```text
Server=tcp:your-server.database.windows.net,1433;Initial Catalog=stocker-demo-db;Persist Security Info=False;User ID=your_admin;Password=your_password;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;
```

ただし、現時点のコードは SQL Server 接続へ未対応です。

## 変更時に見る場所

- API 設定読み込み: [Program.cs](/Users/takase/Source/GitHub-Tks/stocker-ios/StockerWebAPI/src/StockerWebAPI.Api/Program.cs)
- Design-time DB 設定: [AppDbContextFactory.cs](/Users/takase/Source/GitHub-Tks/stocker-ios/StockerWebAPI/src/StockerWebAPI.Api/Data/AppDbContextFactory.cs)
- Azure 用の設定例: [appservice.appsettings.json.example](/Users/takase/Source/GitHub-Tks/stocker-ios/StockerWebAPI/deploy/azure/appservice.appsettings.json.example)
