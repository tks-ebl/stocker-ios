# App Store Metadata Draft

Stocker を App Store Connect に登録するときの下書きです。

前提:

- App Store 公開版は無料アプリとして提供する
- Azure 接続はデモ用途として制限付きで提供する
- 組織向け本運用は、契約済み環境または社内サーバー接続を前提とする
- 公開版の Azure 接続先は固定 URL とする
- 社内運用時は管理者が `https://IPアドレス` を設定する
- `https://IPアドレス` 接続では、証明書の SAN にその IP アドレスを含める

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

無料公開版では、接続先として制限付きのデモ環境を利用できます。
組織導入時は、契約環境または社内サーバー接続での運用を想定しています。
```

### Promotional Text

```text
在庫確認、出荷作業、出荷実績確認の流れを無料で確認できるアプリです。
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
This app is offered as a free public version.
The Azure-backed environment available in the public app is intended for demonstration and evaluation use, and server-side limits may apply.

If the submitted build requires reviewer credentials, provide a dedicated account here.
If local LAN mode is included in the submitted build, explain the required network conditions and how the reviewer can verify the main flows.
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
