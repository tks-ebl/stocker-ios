# App Store Metadata Draft

COMPACT STOCKER を App Store Connect に登録するときの下書きです。

再申請向けの整理版は以下を参照してください。

- `docs/appstore/submission-checklist.md`
- `docs/appstore/review-notes.md`
- `docs/appstore/privacy-mapping.md`
- `docs/appstore/metadata-ja.md`

前提:

- App Store 公開版は無料アプリとして提供する
- 小規模利用向けの一般公開アプリとして提供する
- 基本機能は無料で利用できる
- サーバー側で利用量に一定の上限を設ける場合がある
- 公開版の Azure 接続先は固定 URL とする
- URL 切り替え機能は必要に応じて内部向けに保持するが、公開向け導線では露出しない

## App Information

- Name: `COMPACT STOCKER`
- Subtitle: `小規模向け在庫管理をシンプルに`
- Primary Category: `Business`
- Secondary Category: `Productivity`
- Bundle ID: `ebl.dev.app.Stocker`
- SKU example: `stocker-ios-001`

## Version Information

### Description

```text
COMPACT STOCKER は、在庫確認と出荷作業の流れをシンプルに確認できる iPhone アプリです。

主な機能
・在庫一覧の確認
・在庫履歴の表示
・出荷作業画面での品目確認
・QRコード読み取りによる入力補助
・出荷実績の検索と CSV 出力

小規模な利用を想定し、基本機能を無料で利用できます。
利用量には一部上限がありますが、日々の確認やフリーユース用途でも使いやすい構成を目指しています。
```

### Promotional Text

```text
小規模向けの在庫確認と出荷作業を、無料でシンプルに始められるアプリです。
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
This app is offered as a free public app for small-scale use.
The submitted build connects to a hosted environment for App Review, and some server-side usage limits may apply.

If the submitted build requires reviewer credentials, provide a dedicated account here.
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
