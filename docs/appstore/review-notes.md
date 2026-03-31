# App Review Notes Draft

`App Review Information` の `Notes` 欄に転記するための下書きです。

必要に応じて英語で提出してください。

## English Draft

```text
COMPACT STOCKER is an inventory management app for small-scale use on iPhone.

Main review flow:
1. Launch the app
2. Sign in with the review account below
3. Open the Home screen
4. Check inventory list
5. Open shipping workflow
6. Review shipping results and CSV export

Review account:
- User ID: [REPLACE_ME]
- Password: [REPLACE_ME]

Notes:
- This build connects to the hosted API environment used for App Review.
- The app requires network access to validate login and load inventory and shipping data.
- The app is offered as a free public app for small-scale use, and some usage limits may apply on the server side.
- QR code scanning is available in the shipping workflow. If camera access is denied, the app still remains usable through manual input.
- If any review issue occurs because of account expiration or backend connectivity, please contact us through the support URL listed in App Store Connect.
```

## Japanese Working Draft

```text
COMPACT STOCKER は、小規模利用向けの在庫管理と出荷確認を行える iPhone アプリです。

審査時の確認手順:
1. アプリを起動
2. 下記の審査用アカウントでログイン
3. ホーム画面を確認
4. 在庫一覧を確認
5. 出荷作業画面を確認
6. 出荷実績と CSV 出力を確認

審査用アカウント:
- User ID: [REPLACE_ME]
- Password: [REPLACE_ME]

補足:
- このビルドは App Review 用に公開している API 環境へ接続します。
- ログイン、在庫一覧、出荷関連データの取得にはネットワーク接続が必要です。
- 本アプリは一般公開の無料アプリであり、小規模利用向けにサーバー側で一部利用上限を設ける場合があります。
- QR コード読取は出荷作業画面で利用できます。カメラを許可しない場合でも、手入力で主要機能は確認できます。
- アカウント期限切れやバックエンド接続不良が発生した場合は、App Store Connect に設定したサポート URL からご連絡ください。
```

## Replace Before Submission

- `[REPLACE_ME]` の審査用アカウントを埋める
- 実際の導線に合わせて手順を更新する
- 使えない機能がある場合は事前に書く
- デモ用制限がある場合は書く
