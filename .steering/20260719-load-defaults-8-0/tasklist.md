# タスクリスト

## 🚨 タスク完全完了の原則

**このファイルの全タスクが完了するまで作業を継続すること**

### 必須ルール
- **全てのタスクを`[x]`にすること**
- 「時間の都合により別タスクとして実施予定」は禁止
- 未完了タスク（`[ ]`）を残したまま作業を終了しない
- スキップは技術的理由がある場合のみ（`- [x] ~~タスク名~~（理由）` 形式で明記）

---

## フェーズ1: 準備

- [x] main から作業ブランチ `refactor/1865-load-defaults-8-0` を作成
- [x] bundle install で依存が揃っていることを確認
- [x] docker compose の MySQL / OpenSearch 起動と direnv 環境変数を確認（rspec 実行前提）

## フェーズ2: 実装

- [x] `config/application.rb` の `config.load_defaults 7.1` を `8.0` に変更
- [x] `config/initializers/new_framework_defaults_8_0.rb` を削除
- [x] `config/environments/production.rb` の `cache_classes = true` を `enable_reloading = false` に置換
- [x] `config/environments/development.rb` の `cache_classes = false` を `enable_reloading = true` に置換
- [x] `config/environments/test.rb` の `cache_classes = true` を `enable_reloading = false` に置換

## フェーズ3: 品質チェックと修正

- [x] アプリが正常起動し deprecation 警告が出ないことを確認
  - [x] `bin/rails runner`（development 環境）で起動確認
  - [x] test 環境でも起動確認
- [x] すべてのテストが通ることを確認
  - [x] `bundle exec rspec`（44 examples, 0 failures, 1 pending=既存の未実装 view spec）
- [x] リントエラーがないことを確認
  - [x] `bundle exec rubocop`（今回の変更起因の違反ゼロ。Gemfile の Style/StringLiterals 4件は main 由来の既存違反でスコープ外）

## フェーズ4: 仕上げ

- [x] コミット作成（コミット規約: 日本語1行 + 箇条書き、Co-Authored-By なし）→ a138017
- [x] 実装後の振り返り（このファイルの下部に記録）

---

## 実装後の振り返り

### 実装完了日
2026-07-19

### 計画と実績の差分

**計画と異なった点**:
- コード変更自体は計画どおり（config 5ファイル、+4/-36行）。差分はすべて検証環境の整備で発生した

**新たに必要になったタスク**:
- mysql2 gem の再ビルド: 以前のビルドが削除済みの brew mysql@8.0 の dylib にリンクしていたため、mysql-client@8.0 を導入し `.bundle/config` の build.mysql2 を更新
- colima の VM メモリ増設（2GiB→6GiB, 2CPU→4CPU）: Supabase スタック等と OpenSearch が同居できず OOM（exit 137）を繰り返したため、ユーザー了承のうえ実施
- OpenSearch ボリュームの再作成: `rails8_elasticsearch` ボリュームに旧 Elasticsearch 9 イメージ（stale build）のデータが残っており OpenSearch 2.18 が起動不能（`data/nodes/0: Not a directory`）だったため、`docker compose up -d --build elasticsearch` で現行 Dockerfile から再ビルドし、派生データであるインデックスボリュームを削除・再作成

### 学んだこと

**技術的な学び**:
- 7.1→8.0 の実効差分は railties の `load_defaults` の case 文で機械的に確認できる。8.0 の新デフォルト2項目は initializer で有効化済みだったため一気に引き上げ可能だった
- `to_time_preserves_timezone` は 8.1 で setter 自体が deprecated（8.2 削除予定）で、`to_time` の挙動は設定値を参照しない固定実装。設定を残すと起動毎に警告が出るだけ
- `enable_reloading` は `!cache_classes` の単純ラッパー（railties configuration.rb）なので置換は挙動不変
- `application.rb` の `form_with_generates_remote_forms = true` は UJS の js.erb フローの生命線（#1858/#1864 の同根）。defaults 引き上げ時に消してはいけない

**プロセス上の改善点**:
- 検証前に「ローカル環境が実際に動くか」（gem のネイティブ拡張、docker VM のメモリ、ボリュームの中身）を先に確認すべきだった。実装 10 分に対し環境復旧に大半の時間を費やした

### 次回への改善提案
- `load_defaults 8.1` への引き上げは別 Issue で（escape_json_responses / render_tracker / remove_hidden_field_autocomplete / dev・test での YJIT 無効化の検証が必要）
- ES コンテナのイメージが stale だと Dockerfile と乖離する。`docker compose up --build` を検証手順に含めると再発防止になる
- Gemfile に main 由来の RuboCop 違反（Style/StringLiterals ×4）が残っている。別途軽微 PR で解消可能
