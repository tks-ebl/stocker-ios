# App Store Metadata Draft

Stocker を App Store Connect に登録するときの下書きです。

## App Information

- Name: `Stocker`
- Subtitle: `在庫と出荷をシンプルに確認`
- Primary Category: `Business`
- Secondary Category: `Productivity`
- Bundle ID: `ebl.dev.app.Stocker`
- SKU example: `stocker-ios-001`

## Version Information

### Description

```text
Stocker は、在庫確認と出荷作業の流れをシンプルに確認できる iPhone アプリです。

主な機能
・在庫一覧の確認
・在庫履歴の表示
・出荷作業画面での品目確認
・QRコード読み取りによる入力補助
・出荷実績の検索と CSV 出力

本アプリは、初めてのアプリ開発および App Store 公開の学習を目的として作成されています。
現在のバージョンではサンプルデータを利用しています。
```

### Promotional Text

```text
在庫確認、出荷作業、出荷実績確認をひとつの流れで試せる学習用アプリです。
```

### Keywords

```text
inventory,stock,warehouse,shipping,logistics,qr
```

## URLs

- Support URL: GitHub Pages などで公開した `support.html`
- Privacy Policy URL: GitHub Pages などで公開した `privacy-policy.html`

## App Review Information

### Notes

```text
This app is a practice project for learning iOS app development and App Store release flow.

Login succeeds when both the User ID and Password fields are non-empty.
No dedicated reviewer account is required for the current build.

The app currently uses sample data only and does not require a backend account.
QR-related screens can also be tested with manual text input if needed.
```

## App Privacy

現状の実装から判断すると、App Store Connect の App Privacy は `No, we do not collect data from this app` で回答する前提です。

前提:

- 外部サーバーへの送信なし
- 広告 SDK なし
- 分析 SDK なし
- トラッキングなし

機能追加でデータ収集を始めた場合は更新が必要です。

## Screenshots

最低 1 枚から提出できますが、以下 5 枚を推奨します。

1. ログイン画面
2. ホーム画面
3. 在庫一覧画面
4. 出荷作業画面
5. 出荷実績一覧画面

Apple 公式の要件では、iPhone アプリは 1 から 10 枚のスクリーンショットをアップロードできます。
6.9 インチ用がない場合は、6.5 インチ用が必要です。

## Publish Checklist

1. `docs/support.html` のメールアドレスを本物に変える
2. GitHub Pages などで `docs/` を公開する
3. Support URL と Privacy Policy URL を App Store Connect に入力する
4. App Privacy を回答する
5. スクリーンショットを用意する
6. Review Notes を入力する
7. Archive して TestFlight / App Review へ進める
