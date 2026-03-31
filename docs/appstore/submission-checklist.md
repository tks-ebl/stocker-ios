# App Store Submission Checklist

`COMPACT STOCKER` を App Store Connect で再申請する前の確認チェックリストです。

最終提出前に、すべての項目へチェックを入れられる状態にします。

## 1. Build

- [ ] Release ビルドが Xcode Archive できる
- [ ] App Store Connect に提出対象 Build がアップロード済み
- [ ] `Version` と `Build Number` が意図どおり
- [ ] クラッシュする未完成画面がない
- [ ] デバッグ表示、ダミーボタン、仮文言を消した

## 2. App Behavior

- [ ] 初回起動で主要画面まで進める
- [ ] ログインが必要なら審査用アカウントでログインできる
- [ ] バックエンド API が本番相当環境で動作する
- [ ] Azure 側の API URL が提出ビルドの設定と一致する
- [ ] 主要フローが安定して動く

主要フロー:

- [ ] ログイン
- [ ] ホーム表示
- [ ] 在庫一覧表示
- [ ] 出荷作業
- [ ] 出荷実績確認
- [ ] CSV 出力

## 3. Metadata

- [ ] App Name を確認した
- [ ] Subtitle を確認した
- [ ] Description を確認した
- [ ] Keywords を確認した
- [ ] Category を確認した
- [ ] Support URL を入力した
- [ ] Privacy Policy URL を入力した

転記元:

- [metadata-ja.md](/Users/takase/Source/GitHub-Tks/stocker-ios/docs/appstore/metadata-ja.md)

## 4. Screenshots

- [ ] 6.5 inch 用スクリーンショットを用意した
- [ ] 必要なら 6.9 inch 用も用意した
- [ ] 主要機能が伝わる構成になっている
- [ ] 実装と異なる画面を含めていない
- [ ] ダミーデータの表記が不自然でない

推奨構成:

1. ログイン
2. ホーム
3. 在庫一覧
4. 出荷作業
5. 出荷実績

## 5. App Privacy

- [ ] App Privacy の回答内容を見直した
- [ ] 実装と一致している
- [ ] SDK 追加分を反映した
- [ ] サーバー送信分を反映した

確認元:

- [privacy-mapping.md](/Users/takase/Source/GitHub-Tks/stocker-ios/docs/appstore/privacy-mapping.md)

## 6. App Review Information

- [ ] Review Notes を入力した
- [ ] 審査用アカウントを入力した
- [ ] 審査手順を簡潔に書いた
- [ ] 追加説明が必要な制限事項を明記した
- [ ] デモ版である場合は制約を明記した

転記元:

- [review-notes.md](/Users/takase/Source/GitHub-Tks/stocker-ios/docs/appstore/review-notes.md)

## 7. Support Materials

- [ ] サポートページが公開されている
- [ ] プライバシーポリシーが公開されている
- [ ] 連絡先メールアドレスが実在する
- [ ] ページ内リンク切れがない

既存ファイル:

- [support.html](/Users/takase/Source/GitHub-Tks/stocker-ios/docs/support.html)
- [privacy-policy.html](/Users/takase/Source/GitHub-Tks/stocker-ios/docs/privacy-policy.html)

## 8. Final Gate

- [ ] App Review Guidelines に抵触しそうな機能がない
- [ ] ログインできない、通信できない状態で提出していない
- [ ] 審査担当が社内環境なしで確認できる
- [ ] 提出後に変更が必要なら差し戻し対応手順を把握している

参考:

- [Submit an app](https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/submit-an-app)
- [App Review Guidelines](https://developer.apple.com/appstore/resources/approval/guidelines.html)
