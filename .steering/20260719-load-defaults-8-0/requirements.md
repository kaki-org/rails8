# 要求内容

## 概要

Rails 8.1.3 で稼働中のアプリの `config.load_defaults` を 7.1 から 8.0 へ引き上げ、旧世代の環境設定 API（`cache_classes`）を現行 API に置き換える（Issue [#1865](https://github.com/kaki-org/rails8/issues/1865)）。

## 背景

- `config/application.rb:27` が `config.load_defaults 7.1` のままで、Rails 8.1.3 に対し 2 世代前のデフォルトで動作している
- `config/initializers/new_framework_defaults_8_0.rb` は全 3 項目が有効化済みで、移行完了状態なのにファイルが残っている
- `config/environments/*.rb` が非推奨の旧スタイル `config.cache_classes` を使用している（現行は `config.enable_reloading`）

## 実装対象の機能

### 1. load_defaults の 8.0 への引き上げ
- `config/application.rb` の `config.load_defaults 7.1` → `8.0`
- 7.2 差分（YJIT 有効化、Active Storage webp 対応、migration timestamp 検証、PostgreSQL 専用設定 = MySQL では no-op）と 8.0 差分（strict_freshness、Regexp.timeout = initializer で有効化済み）を一括適用

### 2. new_framework_defaults_8_0.rb の削除
- `strict_freshness` / `Regexp.timeout` は load_defaults 8.0 がカバー
- `to_time_preserves_timezone` は Rails 8.1 で deprecated（8.2 で削除予定）のため、設定ごと削除して deprecation 警告を解消

### 3. 環境設定ファイルの近代化
- `cache_classes` → `enable_reloading` への置換（production / development / test）
- 挙動は変えない（値の反転のみ: `cache_classes = true` ⇔ `enable_reloading = false`）

## 受け入れ条件

### load_defaults 8.0
- [ ] `bin/rails runner` でアプリが正常起動する
- [ ] 起動時に deprecation 警告が出ない（特に to_time_preserves_timezone）
- [ ] `bundle exec rspec` が全件パスする

### 環境設定近代化
- [ ] `cache_classes` の参照が config/ から消えている
- [ ] `bundle exec rubocop` がエラーなし

## 成功指標

- Rails 8.2 へのアップグレード障壁（deprecated 設定）が 1 つ解消される
- new_framework_defaults の管理ファイルが不要になる

## スコープ外

以下はこのフェーズでは実装しません:

- `config.force_ssl` の有効化 — Issue #1860 のスコープ
- Active Storage の :local からの移行 — Issue #1866 のスコープ
- `load_defaults 8.1` への引き上げ — 8.1 差分（escape_json_responses、render_tracker 等）は挙動影響の検証が別途必要なため段階を分ける
- `config/environments/*.rb` の Rails 8 テンプレートでの全面再生成 — force_ssl / storage 等の挙動変更を伴い #1860 / #1866 と衝突するため、今回は deprecated API の置換に留める
- `application.rb:39` の `form_with_generates_remote_forms = true` の削除 — UJS 依存の js.erb フローが現存するため保持（Issue #1858 / #1864 のスコープ）

## 参照ドキュメント

- Issue: https://github.com/kaki-org/rails8/issues/1865
- CLAUDE.md（プロジェクトの開発・テスト前提）
- railties-8.1.3 `lib/rails/application/configuration.rb`（load_defaults 差分の一次情報）
