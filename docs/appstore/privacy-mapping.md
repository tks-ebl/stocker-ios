# App Privacy Mapping

App Store Connect の `App Privacy` 回答を、実装と照合するためのメモです。

このファイルは法的判断そのものではなく、申告のたたき台です。
提出前に、実際のビルド・SDK・送信データを見て最終確認してください。

## Current Assumption

完成版では、バックエンド API と通信し、ログインや業務データを扱う前提で整理します。

そのため、以前の `No, we do not collect data from this app` 前提は再確認が必要です。

## Data Inventory

| データ種別 | 想定有無 | 想定用途 | App Privacy 再確認ポイント |
|---|---|---|---|
| ユーザー ID | あり | ログイン | アカウント管理データに当たるか |
| パスワード | あり | ログイン | 認証情報として扱う |
| 在庫データ | あり | 業務表示 | ユーザー個人データでないか整理 |
| 出荷実績データ | あり | 業務表示、記録 | ユーザーと紐づくか整理 |
| CSV 出力内容 | あり | エクスポート | 端末内のみか、送信するか確認 |
| カメラ利用 | あり | QR 読み取り | データ収集ではなく権限用途説明が主 |
| クラッシュ情報 | 未確認 | 品質改善 | SDK 導入有無を確認 |
| 解析データ | 未確認 | 利用分析 | Analytics SDK があるか確認 |

## Questions To Answer Before Submission

- ログイン情報はサーバー保存されるか
- 業務データに個人識別性があるか
- 利用ログや監査ログをバックエンドで保存するか
- Application Insights などへ個人関連データを送らないか
- 外部 SDK が自動送信する情報はないか

## Practical Guidance

次のどちらに近いかで回答が変わります。

### Case A

バックエンドはあるが、個人データ収集をほぼ行わず、追跡もしない。

この場合でも、ログイン情報や業務上の入力データを Apple の定義上どう扱うか確認が必要です。

### Case B

ログイン情報、利用ログ、監査ログ、クラッシュログなどを保存する。

この場合は `No data collected` と回答しない方が安全です。

## Submission Rule

提出前に、少なくとも以下を確認します。

- 利用中 SDK 一覧
- バックエンドへ送る項目一覧
- 保存するログ一覧
- サポート、監査、障害調査で保管するデータ

## Related Files

- [app-store-metadata.md](/Users/takase/Source/GitHub-Tks/stocker-ios/docs/app-store-metadata.md)
- [support.html](/Users/takase/Source/GitHub-Tks/stocker-ios/docs/support.html)
- [privacy-policy.html](/Users/takase/Source/GitHub-Tks/stocker-ios/docs/privacy-policy.html)
- [Info.plist](/Users/takase/Source/GitHub-Tks/stocker-ios/Stocker/Stocker/Info.plist)
