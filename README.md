# Stocker iOS

`Stocker` は、在庫確認と出荷作業の流れを題材にした iOS アプリです。

初めてのアプリ開発と App Store 公開の練習を兼ねつつ、在庫確認と出荷作業の基本導線を形にしている iPhone アプリです。

バックエンド API はルート配下の `StockerWebAPI` に追加しており、Azure を本番想定、`Docker Compose` をローカル開発想定とした構成です。

## Overview

- SwiftUI ベースの iOS アプリ
- ログイン、ホーム、出荷作業、出荷実績、在庫一覧の画面を実装
- QR コード読み取りによる入力補助に対応
- 倉庫単位のサンプルデータ切り替えに対応

## Current Features

- ログイン画面
  - ユーザー ID / パスワード入力
  - `USER1` から `USER5` のサンプルユーザーでログイン可能
  - Web API 接続時は `worker01` / `leader01` の API ログインに対応
- ホーム画面
  - 当日の状況カード表示
  - 棚卸日の簡易表示
- 出荷作業
  - 出荷日と出荷先コードの入力
  - 出荷プラン一覧の表示
  - ロケーション別の出荷品目確認
  - 実績数量入力
  - QR コード読み取りによる品目検索
- 出荷実績
  - 日付、ユーザーコードでの絞り込み
  - 実績一覧表示
- 在庫一覧
  - 在庫一覧表示
  - 長押しプレビュー
  - 在庫履歴詳細表示

## Tech Stack

- Swift
- SwiftUI
- SwiftData
- AVFoundation
- Xcode project
- ASP.NET Core 8 Web API
- PostgreSQL
- Docker Compose

## Project Status

現在のデータは、サンプルデータと Web API 接続の両方に対応しています。

接続先の考え方は次の 3 モードです。

- 開発用
  - ローカル URL を利用する
  - Docker / ローカル Web API 接続を想定する
- 公開用
  - Azure URL を利用する
  - App Store 公開版の標準接続先とする
- カスタマイズ用
  - 画面から URL を手入力する
  - 顧客環境や社内サーバー接続を想定する

現在のビルド設定は次の初期値です。

- `Debug`
  - `STOCKERConnectionMode = development`
  - `STOCKERDevelopmentAPIBaseURL = http://localhost:8080`
- `Release`
  - `STOCKERConnectionMode = public`
  - `STOCKERPublicAPIBaseURL = https://replace-me.invalid`

カスタマイズ用ビルドを作る場合は、利用するビルド構成で `STOCKERConnectionMode = customize` に変更し、必要に応じて接続設定画面を有効化して使います。

未実装または今後の課題:

- 永続化データの本格利用
- Azure デモ制限の実装反映
- ローカル LAN モードの実装反映
- App Store 公開向けメタデータ整備
- UI/UX の最終調整

## Local Development

1. Xcode で `Stocker/Stocker.xcodeproj` を開く
2. Signing を自分の Apple Developer Team に合わせる
3. 実機または Simulator で起動する

QR コード読み取りはカメラを使うため、実機確認が適しています。

### Web API

1. `StockerWebAPI` ディレクトリへ移動する
2. 必要に応じて `.env.local.example` を元に `.env` を作成する
3. `docker compose up --build` を実行する
4. `http://localhost:8080/swagger` で API を確認する

デモログイン:

- User Code: `worker01`
- Password: `Passw0rd!`

Docker テスト:

- `./scripts/run-docker-tests.sh`

## App Configuration

- Bundle Identifier: `ebl.dev.app.Stocker`
- Display Name: `COMPACT STOCKER`
- Current Version: `0.1`
- Build Number: `1`

## Notes

- `Info.plist` に `NSCameraUsageDescription` を設定済みです
- `Info.plist` に `NSLocalNetworkUsageDescription` を設定済みです
- 現在の iOS アプリは iPhone 専用です
- iPad 対応は将来対応候補として検討します
- 現在の実装は、ビルド設定に応じて接続モードを切り替える構成です
- 公開アプリ版では Azure URL のみを使い、接続切替画面への導線は持たせません
- カスタマイズ版では接続設定画面を有効化し、URL 手入力を許可する想定です
- `Release` の Azure URL は `https://replace-me.invalid` の仮値なので、配布前に実 URL へ更新が必要です
- このリポジトリは App Store 公開の練習も兼ねて段階的に整備中です
- Web API の詳細は `StockerWebAPI/README.md` を参照してください
- Azure 最小構成の運用メモは `docs/deploy-azure-minimal.md`、`docs/config.md`、`docs/operations.md` を参照してください

