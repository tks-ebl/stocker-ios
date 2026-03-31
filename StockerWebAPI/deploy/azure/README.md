# Azure Deployment

`StockerWebAPI` は Docker テスト用の `docker-compose.yml` と、Azure 配置用のテンプレートを分離して管理します。

## Files

- `.env.azure.example`
  - Azure 用の環境変数サンプル
- `containerapp.template.yaml`
  - Azure Container Apps 用のテンプレート
- `appservice.appsettings.json.example`
  - Azure App Service for Containers 用の App Settings サンプル
- `scripts/build-and-push-acr.sh`
  - Docker イメージを ACR へ push する
- `scripts/deploy-containerapp.sh`
  - Container Apps へ反映する
- `scripts/apply-appservice-settings.sh`
  - App Service の環境変数を反映する

## Separation Policy

- ローカル開発と Docker テストは `StockerWebAPI/.env.local.example` と `docker-compose.yml` を使う
- Azure 本番は `deploy/azure/.env.azure.example` を基準に、Container Apps または App Service の環境変数へ投入する
- `SEED__ENABLEDEMOSEED` は Azure 本番では `false`
- 接続文字列と JWT 秘密鍵は Azure 側で Secret として管理する

## Recommended Flow

1. Docker で `./scripts/run-docker-tests.sh` を実行する
2. `./deploy/azure/scripts/build-and-push-acr.sh <acr-name> stockerwebapi-api <tag>` を実行する
3. Container Apps の場合
4. `./deploy/azure/scripts/deploy-containerapp.sh ...` を実行する
5. App Service の場合
6. `appservice.appsettings.json.example` を環境値に合わせて複製し、`./deploy/azure/scripts/apply-appservice-settings.sh ...` を実行する

## Notes

- スクリプト実行には `az` CLI のログインが必要です
- Container Apps と App Service の両方で `ConnectionStrings__Default` と `Jwt__SigningKey` は Secret 扱いにしてください
- ここにあるテンプレートは Docker テスト用設定と分離しており、`docker-compose.yml` は変更せずに共存できます
