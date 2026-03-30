# COMPACT STOCKER データモデル仕様

## 1. 基本方針

- 利用者は作業者単位でログインする
- データ管理単位は所属倉庫単位とする
- 画面上の在庫、出荷、実績は同一倉庫のデータとして扱う

## 2. 主要エンティティ

### 2.1 Warehouse

- 役割
  - データの所属先
- 主な項目
  - warehouseId
  - warehouseCode
  - warehouseName

### 2.2 User

- 役割
  - アプリ利用者
- 主な項目
  - userId
  - userCode
  - userName
  - warehouseId

### 2.3 InventoryItem

- 役割
  - 現在在庫
- 主な項目
  - itemId
  - warehouseId
  - itemCode
  - itemName
  - locationCode
  - quantity

### 2.4 InventoryHistory

- 役割
  - 在庫増減履歴
- 主な項目
  - historyId
  - warehouseId
  - itemId
  - movementDateTime
  - quantityDelta
  - executedByUserId

### 2.5 ShippingPlan

- 役割
  - 出荷予定ヘッダ
- 主な項目
  - shippingPlanId
  - warehouseId
  - shippingDate
  - destinationCode
  - destinationName

### 2.6 ShippingPlanItem

- 役割
  - 出荷予定明細
- 主な項目
  - shippingPlanItemId
  - shippingPlanId
  - itemCode
  - itemName
  - locationCode
  - plannedQuantity
  - actualQuantity

### 2.7 ShippingResult

- 役割
  - 出荷実績
- 主な項目
  - shippingResultId
  - warehouseId
  - itemCode
  - itemName
  - quantity
  - executedByUserCode
  - executedAt

## 3. エンティティ関係

- 1つの `Warehouse` に複数の `User` が所属する
- 1つの `Warehouse` に複数の `InventoryItem` が属する
- 1つの `InventoryItem` に複数の `InventoryHistory` が紐づく
- 1つの `ShippingPlan` に複数の `ShippingPlanItem` が紐づく
- `ShippingResult` は倉庫単位で検索・集計可能にする

## 4. 現在の仮データとの対応

- `InventoryItem.swift`
  - 在庫一覧の仮データ
- `ShippingPlan.swift`
  - 出荷作業の仮データ
- `ShippingResultViewModel.swift`
  - 出荷実績の仮データ

## 5. 将来の DB 方針

- Azure 上の DB に正規データを保持する
- アプリは Web API 経由で取得・更新する
- 倉庫 ID を必須の絞り込み条件として扱う
- DB エンジンは PostgreSQL を採用し、Azure Database for PostgreSQL Flexible Server を本番候補とする
- ローカル開発では Docker 上の PostgreSQL を利用する

## 6. 画面とデータの関係

- ログイン後に所属倉庫が確定する
- ホームは倉庫単位の集計情報を表示する
- 在庫一覧は所属倉庫の在庫のみ表示する
- 出荷作業は所属倉庫の出荷予定のみ表示する
- 出荷実績は所属倉庫の実績のみ検索対象とする

## 7. Web API 初期実装で追加した補助項目

- `User`
  - passwordHash
- `InventoryHistory`
  - reason
- `ShippingResult`
  - shippingPlanId
  - locationCode
  - destinationCode

これらは API の認証、履歴表示、出荷実績追跡を成立させるための補助項目です。
