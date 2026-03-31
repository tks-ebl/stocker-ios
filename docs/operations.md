# Operations Guide

`StockerWebAPI` をデモ運用するための最小運用メモです。

今回は次の前提です。

- 一人運用
- 即応不要
- エラーログ中心
- 可用性よりコスト優先

## 日常確認

週 1 回またはリリース後に、最低限これだけ確認します。

- Container App または App Service が起動している
- `GET /health` が通る
- エラーログが急増していない
- Azure の月額見込みが予算内

## 障害時の見方

### API が落ちていそうなとき

確認順:

1. Container Apps または App Service の `Overview` で稼働状態を確認する
2. `Log stream` または Application Insights で例外を確認する
3. Azure 側の環境変数に欠落がないか確認する
4. `GET /health` を再確認する

### DB 接続エラーのとき

確認順:

1. 接続文字列が正しいか確認する
2. PostgreSQL Flexible Server 側のネットワーク制御を確認する
3. SSL 必須接続文字列になっているか確認する
4. アプリ実装と DB 種別が一致しているか確認する

補足:

現在の `StockerWebAPI` は PostgreSQL 前提です。

## 再起動の考え方

デモ用途では、問題切り分けのために Container App または App Service の再起動を使ってよいです。

再起動前に見る項目:

- 環境変数を変更した直後か
- デプロイ直後か
- DB 側の接続制御変更が入っていないか

## コスト確認

月額 10,000 円を超えないよう、以下を確認します。

- Container Apps または App Service のサイズを上げすぎていない
- ログを取りすぎていない
- DB が想定より大きくなっていない

予算通知は以下を目安にします。

- 50%
- 80%
- 100%

## 変更時のメモ

本番設定を変更したときは、最低限これを残します。

- 変更日
- 何を変えたか
- なぜ変えたか
- 戻し方

この記録は PR、Issue、または別の運用メモに寄せても構いません。

## 現在の注意点

このリポジトリの API は、現時点では PostgreSQL 前提です。

そのため、Azure 側も PostgreSQL Flexible Server を前提に運用するのが自然です。
