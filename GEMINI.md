# GEMINI.md (Project Specific)

このリポジトリは、Rails 8 を使用したイベント管理アプリケーション `rails8` の開発における Antigravity の動作指針です。

## 1. プロジェクト概要
- **目的**: ユーザーがイベントを作成・管理し、他のユーザーが参加（チケット登録）できるイベント管理システム。
- **認証**: GitHub OAuth (OmniAuth) を採用。
- **主要機能**: イベント作成・編集・削除、画像アップロード (Active Storage)、イベント検索 (Searchkick/Elasticsearch)、参加登録 (Tickets)。

## 2. 技術スタック & 開発環境
- **Runtime**: Ruby 4.0.1, Node.js 24.14.0, pnpm 10.28.2
- **Framework**: Rails 8.1.0
- **Database**: MySQL 8.0/9.6
- **Search**: Elasticsearch 7.17.9 + Searchkick
- **Background Jobs**: Sidekiq
- **Frontend**: Bootstrap 5.3.7, Hamlit (Template), Stimulus, Turbo, Webpack 5
- **Testing**: RSpec, Capybara (Playwright), SimpleCov
- **Linting**: RuboCop (rubocop-rails, rubocop-performance)

## 3. 開発コマンド (Workflow)
開発操作は原則として `dip` (Docker Interaction Process) を使用します。

### 基本操作
- `dip up` - 開発環境の起動
- `dip bundle install` - 依存関係のインストール
- `dip pnpm install` - JS依存関係のインストール
- `dip rails db:migrate` - マイグレーション実行

### テスト & 静的解析
- `dip rspec` - 全テストの実行
- `dip rspec spec/models/` - モデルテストのみ実行
- `dip rubocop` - 静的解析の実行
- `dip rubocop -a` - 自動修正

### 検索エンジン
- `dip rails searchkick:reindex CLASS=Event` - 検索インデックスの再構築

## 4. コーディング規約 & 設計指針
- **Ruby/Rails**: `.rubocop.yml` に準拠。日本語コメントを許容。
- **Template**: 全てのビューは Hamlit (`.html.haml`) を使用する。
- **Aesthetics**: Bootstrap 5 をベースにしつつ、カスタムスタイルが必要な場合は Vanilla CSS (SCSS) を使用してプレミアムなデザインを追求する。
- **Forms**: 複雑な検索ロジックなどは `app/forms/event_search_form.rb` のようにフォームオブジェクトを活用する。
- **Search**: `Event` モデルの検索は `Searchkick` を介して行う。

## 5. 安全ルール (Mandatory)
グローバルな `GEMINI.md` のルールに加え、以下の点に留意してください。
1. **既存ファイルの編集**: 既存のロジックを変更・上書きする際は、必ず変更内容を説明し、ユーザーの承認を得ること。
2. **削除禁止**: `rm`, `dip rails db:drop` などの破壊的な操作は、明確な指示がない限り実行しない。
3. **コマンド実行**: `dip` を経由するコマンドが多いため、実行前にどの環境（ホスト or コンテナ）で実行するかを明示する。
4. **型安全**: 可能であればコードの堅牢性を意識した実装を行う。

## 6. コミュニケーション
- 日本語を第一言語とし、論理的かつ親しみやすいトーンで応対する。
- エンジニアではないユーザーが理解できるよう、技術的な操作については平易な言葉で説明を添える。
