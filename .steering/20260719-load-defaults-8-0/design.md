# 設計書

## アーキテクチャ概要

コード変更は設定ファイル 5 ファイルのみ。アプリケーションコードには触れない。

```
config/application.rb                              load_defaults 7.1 → 8.0
config/initializers/new_framework_defaults_8_0.rb  削除
config/environments/production.rb                  cache_classes → enable_reloading
config/environments/development.rb                 cache_classes → enable_reloading
config/environments/test.rb                        cache_classes → enable_reloading
```

## 変更内容の根拠（railties-8.1.3 実測）

### load_defaults 7.1 → 8.0 で新たに適用されるデフォルト

| 設定 | 影響 |
|------|------|
| `self.yjit = true`（7.2） | YJIT 有効化。パフォーマンス改善のみ |
| `active_storage.web_image_content_types` に webp 追加（7.2） | variant 生成時の扱いのみ。既存画像に影響なし |
| `active_record.validate_migration_timestamps = true`（7.2） | 新規マイグレーション作成時のみ |
| `active_record.postgresql_adapter_decode_dates = true`（7.2） | MySQL のため no-op |
| `action_dispatch.strict_freshness = true`（8.0） | initializer で有効化済み → 挙動変化なし |
| `Regexp.timeout \|\|= 1`（8.0） | initializer で有効化済み → 挙動変化なし |

### new_framework_defaults_8_0.rb を削除できる理由

- `strict_freshness` / `Regexp.timeout` → load_defaults 8.0 がカバー
- `to_time_preserves_timezone = :zone` → activesupport-8.1.3 で setter 自体が deprecated（"will be removed in Rails 8.2"）。設定を残すと起動毎に deprecation 警告が出る。8.1 では :zone 相当が固定挙動のため削除で挙動変化なし

### cache_classes → enable_reloading

railties-8.1.3 では `enable_reloading = !cache_classes` の関係（configuration.rb:380-384）。値を反転して置換する:

- production.rb: `cache_classes = true` → `enable_reloading = false`
- development.rb: `cache_classes = false` → `enable_reloading = true`
- test.rb: `cache_classes = true` → `enable_reloading = false`

### 保持するもの（罠になりやすい点）

- `application.rb:39` `config.action_view.form_with_generates_remote_forms = true` — actionview-8.1.3 に現存する有効な API。UJS の js.erb フローがこれに依存しているため、削除すると #1858 の 500 が顕在化する。**触らない**

## エラーハンドリング戦略

設定変更のみのためカスタムエラー処理は不要。リスクは「起動不能」「テスト失敗」の 2 点で、検証フェーズで検出する。

## テスト戦略

### 起動スモークテスト
- `bin/rails runner` での起動確認と、stderr の deprecation 警告チェック

### 回帰テスト
- `bundle exec rspec` 全件（要 docker compose の MySQL/OpenSearch + direnv）
- `bundle exec rubocop`（CI では走らないため手動必須 — CLAUDE.md）

## 依存ライブラリ

追加なし。

## 実装の順序

1. main から `refactor/1865-load-defaults-8-0` ブランチ作成
2. application.rb の load_defaults 変更
3. new_framework_defaults_8_0.rb 削除
4. environments 3 ファイルの cache_classes 置換
5. 起動確認 → rspec → rubocop
6. コミット

## セキュリティ考慮事項

- Regexp.timeout / strict_freshness は既に有効のため、セキュリティ姿勢の後退はない
- force_ssl には触れない（#1860）

## パフォーマンス考慮事項

- YJIT が production で有効化される（7.2 デフォルト）。メモリ使用量が微増する可能性があるが、Rails 公認のデフォルト

## 将来の拡張性

- 8.0 到達後、次のステップとして `load_defaults 8.1`（escape_json_responses / render_tracker / remove_hidden_field_autocomplete 等の検証が必要）を別 Issue で実施可能
