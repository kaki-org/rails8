# 技術スタック

## バックエンドフレームワーク

- **Ruby**: 3.4.5
- **Rails**: 8.0.0
- **データベース**: MySQL 8.0/9.3
- **テンプレートエンジン**: Hamlit（HAML ベース）
- **バックグラウンドジョブ**: Sidekiq
- **ファイルストレージ**: Active Storage（VIPS画像処理）

## フロントエンドスタック

- **JavaScript**: Stimulus Rails, Turbo Rails, jQuery
- **CSSフレームワーク**: Bootstrap 5.3.7（SCSS使用）
- **ビルドシステム**: Webpack（カスタム設定）
- **モジュールシステム**: Importmap Rails + JS Bundling Rails
- **その他**: Vue.js 3（限定的な使用）

## 主要ライブラリ・サービス

- **認証**: OmniAuth（GitHubプロバイダー）
- **検索**: Searchkick + OpenSearch/Elasticsearch
- **ページネーション**: Kaminari
- **国際化**: Rails I18n（日本語がデフォルト）
- **コード品質**: RuboCop, Bullet（N+1検出）, Brakeman（セキュリティ）
- **テスト**: RSpec, Capybara（Playwrightドライバー）, FactoryBot

## 開発環境

- **コンテナ化**: Docker + Docker Compose
- **開発ツール**: dip（Docker Interaction Process）
- **パッケージマネージャー**: pnpm（Node.js依存関係）

## よく使うコマンド

### 開発環境セットアップ

```bash
# dip使用（推奨）
dip provision                    # 完全な環境セットアップ
dip up                          # 全サービス開始
dip rails s                     # Railsサーバー開始
dip bash                        # コンテナシェルアクセス

# データベース操作
dip rails db:create db:migrate
dip rails searchkick:reindex CLASS=Event  # 検索機能に必要
```

### テスト・品質チェック

```bash
dip rspec                       # テストスイート実行
dip rubocop                     # コードスタイルチェック
dip brakeman                    # セキュリティスキャン
```

### アセット管理

```bash
dip yarn build                  # フロントエンドアセットビルド
dip rails assets:precompile     # 本番用プリコンパイル
```

### Docker操作

```bash
docker-compose up -d            # バックグラウンドでサービス開始
docker-compose down --volumes   # サービス停止・ボリューム削除
```

## 設定メモ

- タイムゾーン: 'Asia/Tokyo'に設定
- デフォルトロケール: 日本語（:ja）
- フォームヘルパーはデフォルトでリモートフォームを生成
- アセットパイプラインは安定性のためconcurrent: falseを使用
- 画像バリアント処理にVIPSを使用