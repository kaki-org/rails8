# CLAUDE.md

このファイルは Claude Code（claude.ai/code）がこのリポジトリを扱う際のガイドとして使用されます。

## プロジェクト概要

Rails 8 で構築されたイベント管理Webアプリケーションです。ユーザーはイベントの作成・編集・管理が可能で、他のユーザーはイベントの閲覧やチケット登録（参加登録）ができます。GitHub OAuth による認証を採用しています。

## 技術スタック

- **Ruby**: 4.0.1（.tool-versions で管理）
- **Rails**: 8.1.0
- **Node.js**: 24.13.0
- **パッケージマネージャ**: pnpm 10.28.2
- **データベース**: MySQL 8.0/9.6（mysql2 アダプタ）
- **検索エンジン**: Elasticsearch 7.17.9 + Searchkick
- **バックグラウンドジョブ**: Sidekiq
- **テンプレートエンジン**: Hamlit
- **フロントエンド**: Stimulus、Turbo、Bootstrap 5、jQuery、Vue.js 3
- **アセットバンドル**: Webpack 5 + jsbundling-rails

## よく使うコマンド

### 開発環境

```bash
bundle install                    # Rubyの依存関係をインストール
pnpm install                      # JavaScriptの依存関係をインストール
bundle exec rails db:create       # データベースを作成
bundle exec rails db:migrate      # マイグレーションを実行
bundle exec rails assets:precompile  # アセットをビルド
bundle exec rails server          # 開発サーバーを起動
```

### テスト

```bash
bundle exec rspec                 # 全テストを実行
bundle exec rspec spec/models/    # モデルのテストのみ実行
bundle exec rspec spec/requests/  # リクエストのテストのみ実行
bundle exec rspec spec/some_spec.rb  # 特定のテストファイルを実行
```

### コード品質

```bash
bundle exec rubocop               # RuboCopによる静的解析を実行
bundle exec rubocop -a             # 自動修正可能な違反を修正
bundle exec brakeman               # セキュリティ脆弱性のスキャンを実行
```

## アーキテクチャ

### ディレクトリ構成

- `app/controllers/` - Railsコントローラ（sessions, events, tickets, welcome など）
- `app/models/` - ActiveRecordモデル（User, Event, Ticket）
- `app/views/` - Hamlitテンプレート（.haml ファイル）
- `app/forms/` - フォームオブジェクト
- `app/jobs/` - Sidekiqバックグラウンドジョブ
- `app/javascript/` - ESモジュール（Stimulus コントローラなど）
- `app/assets/` - SCSS スタイルシートと画像
- `spec/` - RSpecテスト
- `spec/factories/` - FactoryBotのファクトリ定義

### 主要モデル

- **User** - GitHub OAuth で認証されるユーザー
- **Event** - イベント情報（画像アップロード対応、Active Storage使用）
- **Ticket** - イベントへの参加登録

### 認証

OmniAuth + omniauth-github による GitHub OAuth 認証を使用しています。

## テスト

- **フレームワーク**: RSpec
- **テストデータ**: FactoryBot
- **カバレッジ**: SimpleCov（coverage/ ディレクトリに出力）
- **CI**: GitHub Actions（PR作成時に自動実行）
- **CI構成**: RSpec実行 → Brakeman → Codecov

## コーディング規約

- RuboCop（rubocop-rails, rubocop-performance プラグイン使用）に準拠
- `.rubocop.yml` と `.rubocop_todo.yml` で設定を管理
- 日本語コメントが許可されています（`Style/AsciiComments: Enabled: false`）
- テンプレートは Hamlit（.haml）を使用
- i18n による日本語対応（rails-i18n gem）
