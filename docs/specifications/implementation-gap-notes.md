# COMPACT STOCKER 実装ギャップと課題メモ

## 1. 文書の目的

この文書は、仕様書と現在の実装を見比べたときの差分を整理するためのメモです。

仕様として維持したい内容と、まだ未実装の内容を混同しないことを目的にします。

## 2. 2026-03-30 時点で実装済みの主な項目

- `StockerWebAPI` の ASP.NET Core Web API
- PostgreSQL 接続
- EF Core Migration 管理
- JWT ログイン API
- 在庫一覧、在庫履歴、出荷予定、出荷実績検索、出荷実績登録 API
- Docker 起動
- Docker ベースの unit test / smoke test
- Azure 配置用の設定雛形とスクリプト雛形

## 3. iOS 側の未実装

- Web API への接続
- JWT 保持と再ログイン制御
- 接続先切替 UI
- ローカル LAN モードの設定導線
- `NSLocalNetworkUsageDescription` を前提にした実接続確認
- Azure デモ制限の UI 反映
- API 連携前提のクライアント層や責務分離

補足:

- 接続先設定はアプリ内画面として持たせる方針
- Azure デモ制御は初期版から入れる方針
- ローカル LAN モードは App Store 公開版と同一アプリ内で扱う方針

## 3.1 iOS 側で実装済みになった項目

- サンプルユーザー `USER1` から `USER5` によるログイン
- ログイン時の所属倉庫確定
- 倉庫単位の在庫一覧、出荷プラン、出荷実績の絞り込み
- ホーム画面での倉庫単位ダッシュボード表示
- iPhone 専用設定

## 4. Web API 側の未実装

- Azure デモ制限
  - `demo-limit-api-spec.md` の制限判定は未実装
- リフレッシュトークン
- ユーザー管理 API
- CSV 出力 API
- 出荷実績削除 API
- 監査ログや操作履歴の永続化
- 本番向けの認証鍵ローテーション設計

## 5. 運用面の未完了

- Azure Container Apps / App Service への実環境デプロイ確認
- ACR、Container Apps、Flexible Server の実リソース作成手順の確定
- LAN 用 HTTPS 証明書の配布手順
- App Store 審査向けのローカル LAN 再現説明

## 6. 次の優先候補

1. iOS 側を Web API へ接続する
2. Azure デモ制限を API に反映する
3. 接続設定画面、Azure デモ制御、ローカル LAN モードを iOS に追加する
4. Azure 実環境へ一度デプロイして手順を確定する

## 7. 補足メモ

- `admin-connection-setting-spec.md`
- `demo-limit-api-spec.md`
- `local-lan-api-spec.md`

これらは将来の実装仕様であり、現時点では iOS アプリに未反映の項目を含む。
ただし、接続設定はアプリ内画面、Azure デモ制御は初期版導入、ローカル LAN モードは同一アプリ内同梱という方針は確定済みとする。
