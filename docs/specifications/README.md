# 仕様書一覧

`COMPACT STOCKER` の仕様書一覧です。

## 目的別の参照先

- プロダクト全体像を確認したい
  - `product-spec.md`
- まずどこまで作るかを確認したい
  - `mvp-scope.md`
- 画面ごとの役割や遷移を確認したい
  - `screen-spec.md`
- 管理者向けの接続設定 UI を確認したい
  - `admin-connection-setting-spec.md`
- データ構造を整理したい
  - `data-model-spec.md`
- ログインと倉庫判定の考え方を確認したい
  - `auth-spec.md`
- Azure / Web API 前提の連携方針を確認したい
  - `api-integration-spec.md`
- Azure デモ制限の API 応答を確認したい
  - `demo-limit-api-spec.md`
- Azure / ローカル LAN 切替の条件を確認したい
  - `local-lan-api-spec.md`
- 現在の実装差分と残課題を確認したい
  - `implementation-gap-notes.md`
- 品質面や公開判断の基準を確認したい
  - `nonfunctional-spec.md`
- 実装済みの Web API 構成と起動方法を確認したい
  - `../../StockerWebAPI/README.md`

## 補足

- `admin-connection-setting-spec.md`
- `demo-limit-api-spec.md`
- `local-lan-api-spec.md`

これらは将来実装向けの仕様を含みます。2026-03-31 時点では、iOS 側に未反映の項目と、方針のみ確定済みの項目が混在しています。

- `接続設定` はアプリ内画面として持たせる方針を採用する
- Azure デモ制限は初期版から入れる方針を採用する
- ローカル LAN モードは App Store 公開版と同一アプリ内で扱う方針を採用する

## 更新ルール

- 機能追加前に関連仕様を確認する
- 実装方針を変えたら対応する仕様書も更新する
- App Store 向け説明文は、仕様書と矛盾しない内容にする
