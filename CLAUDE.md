# CLAUDE.md

このファイルは Claude Code（claude.ai/code）がこのリポジトリを扱う際のガイドとして使用されます。

## プロジェクト概要

Rails 8 のイベント管理アプリ。ユーザーはイベントを作成・編集し、他のユーザーはチケット登録（参加登録）する。認証は GitHub OAuth のみ。テンプレートは Hamlit（.haml）。

## バージョンの正

Ruby / Node.js は .tool-versions、pnpm は package.json の packageManager が正。このファイルにバージョン数値は書かない（更新漏れで嘘になるため）。

## 検索エンジン

searchkick を使うが、接続先は Elasticsearch ではなく OpenSearch（config/initializers/searchkick.rb で OpenSearch::Client に差し替え済み）。環境変数名は歴史的経緯で ELASTIC_SEARCH_URL のまま。CI だけは Elasticsearch 7.17.9 で動くため、どちらか一方にしかない API は使わない。

## 開発・テスト実行の前提

- DB（MySQL）と OpenSearch は docker-compose で動かし、接続情報は .envrc（direnv）が供給する（MYSQL_HOST=rails-db.lvh.me / MYSQL_PORT=53306）。コンテナ未起動や direnv 未ロードの状態で bundle exec rspec を実行すると接続エラーで全滅する
- Searchkick のテスト用スタブは無く、検索を検証する spec は実エンジンに接続する
- JS パッケージ操作は pnpm のみ（pnpm-lock.yaml が正）
- アセットビルドは bundle exec rails assets:precompile（内部で pnpm build を呼ぶ）。webpack 設定はルートではなく config/webpack/webpack.config.js にある

## 品質チェック

- CI（PR 時）は Brakeman → RSpec → Codecov のみで、RuboCop は走らない。コミット前に手動で bundle exec rubocop を実行する
- 日本語コメント可（Style/AsciiComments 無効）

## ブランチ・PR

- PR は main ベース
- ブランチ名は feature/ fix/ chore/ refactor/ doc/ のプレフィックスを付ける（release-drafter がラベルを自動付与するため）
