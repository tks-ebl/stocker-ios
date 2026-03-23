# Stocker iOS

`Stocker` は、在庫確認と出荷作業の流れを題材にした iOS アプリです。

初めてのアプリ開発と App Store 公開の練習を目的に作成しており、現在は実運用向けではなく、画面遷移や基本機能の確認ができるプロトタイプ段階です。

## Overview

- SwiftUI ベースの iOS アプリ
- ログイン、ホーム、出荷作業、出荷実績、在庫一覧の画面を実装
- QR コード読み取りによる入力補助に対応
- 出荷実績の CSV 出力に対応

## Current Features

- ログイン画面
  - ユーザー ID / パスワード入力
  - 現在はモック実装で、API 認証は未接続
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
  - CSV 出力と共有
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

## Project Status

現在のデータはサンプルデータを利用しています。

未実装または今後の課題:

- バックエンド API 連携
- 本物のログイン認証
- 永続化データの本格利用
- App Store 公開向けメタデータ整備
- UI/UX の最終調整

## Local Development

1. Xcode で `Stocker/Stocker.xcodeproj` を開く
2. Signing を自分の Apple Developer Team に合わせる
3. 実機または Simulator で起動する

QR コード読み取りはカメラを使うため、実機確認が適しています。

## App Configuration

- Bundle Identifier: `ebl.dev.app.Stocker`
- Display Name: `Stocker`
- Current Version: `0.1`
- Build Number: `1`

## Notes

- `Info.plist` に `NSCameraUsageDescription` を設定済みです
- ローカルネットワーク向けの ATS 例外設定が含まれています
- このリポジトリは App Store 公開の練習も兼ねて段階的に整備中です

