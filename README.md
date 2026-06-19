# Rails 8 イベント管理アプリケーション

Rails 8 を使用したイベント管理・参加申込みシステムです。ユーザーがイベントを作成・管理し、他のユーザーがそのイベントに参加申込みできる Web アプリケーションです。

## 🚀 主な機能

### イベント管理

- **イベント作成・編集・削除**: 認証済みユーザーがイベントを管理
- **イベント詳細表示**: 誰でもイベント詳細を閲覧可能
- **画像アップロード**: イベントに画像を添付（Active Storage 使用）
- **検索機能**: キーワードによるイベント検索（Searchkick + OpenSearch）
- **ページネーション**: イベント一覧のページ分割表示

### ユーザー管理

- **GitHub OAuth 認証**: GitHub アカウントでのログイン
- **ユーザープロフィール**: 名前、アバター画像の管理
- **アカウント削除**: 未終了イベントがない場合のみ削除可能

### 参加管理（チケット機能）

- **イベント参加申込み**: 認証済みユーザーがイベントに参加表明
- **参加キャンセル**: 参加申込みの取り消し
- **参加者一覧**: イベントの参加者とコメントを表示
- **コメント機能**: 参加時にコメントを添付可能

## 🛠 技術スタック

### バックエンド

- **Ruby**: 3.4.5
- **Rails**: 8.0.0
- **データベース**: MySQL 8.0
- **認証**: OmniAuth (GitHub)
- **検索**: Searchkick + OpenSearch
- **バックグラウンドジョブ**: Sidekiq
- **ファイルアップロード**: Active Storage
- **テンプレートエンジン**: Hamlit

### フロントエンド

- **JavaScript**: Stimulus Rails, Turbo Rails
- **CSS**: Bootstrap 5.3.7, SCSS
- **バンドラー**: Webpack
- **その他**: jQuery, Vue.js 3

### 開発・運用

- **コンテナ**: Docker, Docker Compose
- **開発支援**: dip (Docker Interaction Process)
- **テスト**: RSpec, Capybara (Playwright driver)
- **コード品質**: RuboCop, Bullet (N+1 クエリ検出)
- **カバレッジ**: SimpleCov

## 📊 データベース構造

### テーブル構成

- **users**: ユーザー情報（GitHub OAuth）
- **events**: イベント情報（名前、場所、内容、開始/終了時間）
- **tickets**: 参加申込み情報（ユーザーとイベントの関連）
- **active*storage*\***: ファイルアップロード関連

### 主要な関連

- User has_many Events (as owner)
- User has_many Tickets
- Event has_many Tickets
- Event has_one_attached :image

## 🚀 セットアップ

### 前提条件

- Docker & Docker Compose
- MySQL 8.0 (ローカル開発の場合)

### 初期構築

1. **MySQL 設定** (ローカル開発の場合)

```bash
brew install mysql@8.0
bundle config --local build.mysql2 "--with-mysql-dir=$(brew --prefix mysql@8.0)"
```

2. **アプリケーション起動**

```bash
# Dockerを使用する場合
docker-compose up

# dipを使用する場合
dip bundle
dip rails new .
dip up
```

3. **データベース初期化**

```bash
dip rails db:create db:migrate
dip rails searchkick:reindex CLASS=Event
```

### 環境変数

- `MYSQL_HOST`: MySQL ホスト (デフォルト: localhost)
- `MYSQL_PORT`: MySQL ポート (デフォルト: 3306)
- GitHub OAuth 設定が必要

## 🧪 テスト

```bash
# テスト実行
dip rspec

# カバレッジ確認
open coverage/index.html
```

## 📝 開発メモ

### ルーティング確認

<http://localhost:3000/rails/info/routes>

### Sidekiq 管理画面

<http://localhost:3000/sidekiq>

### Docker 関連

**通常の Dockerfile**

```bash
docker build -t myrailsapp .
docker run -p 3000:3000 myrailsapp
```

**BuildKit 使用**

```bash
DOCKER_BUILDKIT=1 docker build -t myrailsapp -f Dockerfile-buildkit .
docker run -p 3000:3000 myrailsapp
```

## 🔧 既知の問題・TODO

### 検索機能

- 初回起動時に `Event.reindex` の実行が必要
- `Searchkick::MissingIndexError` が発生する場合は以下を実行:

```bash
dip rails searchkick:reindex CLASS=Event
```

### その他

- [ ] 他のユーザが作成したイベントに参加できない問題の修正
- [ ] Sidekiq の動作確認と修正
- [ ] プロダクション環境での設定最適化

## 📄 ライセンス

このプロジェクトは MIT ライセンスの下で公開されています。
