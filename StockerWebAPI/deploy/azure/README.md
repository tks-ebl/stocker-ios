# Azure Deployment

`StockerWebAPI` は Docker テスト用の `docker-compose.yml` と、Azure 配置用のテンプレートを分離して管理します。

## Files

- `.env.azure.example`
  - Azure 用の環境変数サンプル
- `containerapp.template.yaml`
  - Azure Container Apps 用のテンプレート

## Separation Policy

- ローカル開発と Docker テストは `StockerWebAPI/.env.local.example` と `docker-compose.yml` を使う
- Azure 本番は `deploy/azure/.env.azure.example` を基準に、Container Apps または App Service の環境変数へ投入する
- `SEED__ENABLEDEMOSEED` は Azure 本番では `false`
- 接続文字列と JWT 秘密鍵は Azure 側で Secret として管理する

## Recommended Flow

1. Docker で `./scripts/run-docker-tests.sh` を実行する
2. API イメージをビルドして ACR へ push する
3. `containerapp.template.yaml` を環境値に合わせて反映する
4. PostgreSQL Flexible Server の接続情報を Secret 化して注入する

