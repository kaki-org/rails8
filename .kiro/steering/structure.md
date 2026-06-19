# プロジェクト構造

## Railsアプリケーションレイアウト

### コアアプリケーション構造

```
app/
├── controllers/          # リクエスト処理ロジック
│   ├── application_controller.rb
│   ├── events_controller.rb     # イベントCRUD操作
│   ├── sessions_controller.rb   # OAuth認証
│   ├── tickets_controller.rb    # イベント参加
│   ├── retirements_controller.rb # アカウント削除
│   └── welcome_controller.rb    # ランディングページ
├── models/              # ビジネスロジック・データモデル
│   ├── event.rb         # Searchkick統合イベントモデル
│   ├── user.rb          # OAuth対応ユーザーモデル
│   └── ticket.rb        # イベント参加モデル
├── views/               # Hamlitテンプレート
│   ├── events/          # イベント管理ビュー
│   ├── tickets/         # 参加ビュー
│   ├── retirements/     # アカウント削除ビュー
│   └── welcome/         # ランディングページ
├── forms/               # フォームオブジェクト
│   └── event_search_form.rb
└── helpers/             # ビューヘルパーメソッド
```

### フロントエンドアセット

```
app/assets/
├── stylesheets/         # SCSSファイル
│   ├── application.scss # メインスタイルシート
│   └── [controller].scss # コントローラー固有スタイル
└── javascript/          # レガシーJSファイル
    ├── application_legacy.js
    └── get_form_turbolinks.js
```

### 設定構造

```
config/
├── environments/        # 環境固有設定
├── initializers/        # アプリ初期化コード
│   ├── omniauth.rb     # OAuth設定
│   ├── searchkick.rb   # 検索設定
│   └── rack_profiler.rb # パフォーマンス監視
├── locales/            # I18n翻訳ファイル
│   ├── en.yml
│   ├── ja.yml          # プライマリロケール
│   └── kaminari_ja.yml # ページネーション翻訳
├── application.rb      # メインアプリ設定
├── routes.rb          # URLルーティング
└── database.yml       # データベース設定
```

## データモデル関係

### コアモデル

- **User**: GitHub OAuthユーザー
  - `has_many :created_events`（作成者として）
  - `has_many :tickets`（イベント参加）
  - `has_many :participating_events`（ticketsを通じて）

- **Event**: 検索機能付きイベントエンティティ
  - `belongs_to :owner`（User）
  - `has_many :tickets`（参加者）
  - `has_one_attached :image`（Active Storage）
  - 全文検索用Searchkickを含む

- **Ticket**: イベント参加記録
  - `belongs_to :user`
  - `belongs_to :event`
  - オプションのコメントフィールド

## 開発・テスト構造

### テスト構成

```
spec/
├── factories/           # FactoryBotテストデータ
├── models/             # モデル単体テスト
├── requests/           # コントローラー統合テスト
├── views/              # ビューレンダリングテスト
└── support/            # テストヘルパー・設定
```

### 開発ツール

```
.rubocop.yml            # Rubyスタイル設定
.rubocop_todo.yml       # 一時的スタイル例外
dip.yml                 # Docker操作コマンド
docker-compose.yml      # コンテナオーケストレーション
```

## 主要アーキテクチャパターン

### 認証フロー

- OAuthコールバックは`SessionsController`で処理
- `User.find_or_create_from_auth_hash!`によるユーザー作成・検索
- セッションベース認証（JWT/トークンなし）

### 検索実装

- EventモデルにSearchkick gem統合
- OpenSearch/Elasticsearchバックエンド
- 日本語サポート設定済み
- 手動再インデックスが必要: `Event.reindex`

### ファイルアップロードパターン

- イベント画像用Active Storage
- 画像バリアント用VIPSプロセッサー
- Eventモデルでサイズ・寸法検証
- チェックボックスによるオプション画像削除

### バックグラウンドジョブ

- 非同期処理用Sidekiq
- ジョブキュー用Redisバックエンド
- Docker ComposeのWorkerサービス

## 命名規則

- コントローラー: 複数形名詞（EventsController）
- モデル: 単数形名詞（Event, User, Ticket）
- ビュー: コントローラーアクションに対応
- ルート: ネストしたリソースでRESTful規約
- データベース: テーブル・カラム名はsnake_case
- クラス: PascalCase
- メソッド・変数: snake_case