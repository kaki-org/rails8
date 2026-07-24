# 要件: OpenSearch 移行の残作業

対象 Issue: https://github.com/kaki-org/rails8/issues/1842

## 背景

実装（Gemfile / config/initializers/searchkick.rb）は OpenSearch に移行済みだが、
ドキュメント・CI・コンテナ定義の一部が Elasticsearch を参照したままで乖離している。

## Issue 記載内容の現況確認（2026-07-20 時点）

| Issue の指摘 | 現況 | 対応 |
|---|---|---|
| `CLAUDE.md:16` が Elasticsearch 表記 | **修正済み**（OpenSearch と明記） | CI 移行に伴う追記のみ |
| `GEMINI.md:8,14` が Elasticsearch 表記 | 未対応 | 要修正 |
| `devenv/elasticsearch/Dockerfile` が ES イメージ | **修正済み**（`opensearchproject/opensearch:2.18.0`） | ディレクトリ名のみ要リネーム |
| CI が Elasticsearch 7.17.9 を起動 | 未対応 | 要修正 |
| env 名 `ELASTIC_SEARCH_URL` | 未対応 | 要修正（互換維持） |

## 要件

1. **R1**: `GEMINI.md` の検索エンジン表記を OpenSearch 実態に合わせる
2. **R2**: `devenv/elasticsearch/` を `devenv/opensearch/` にリネームし、`docker-compose.yml` /
   `dip.yml` のサービス名・ボリューム名も `opensearch` に統一する
3. **R3**: CI（`.github/workflows/ruby.yml`）の検索バックエンドを OpenSearch に差し替える。
   `searchkick language: 'japanese'` が analysis-kuromoji を必要とするため、
   プラグイン入りイメージを使うこと
4. **R4**: 環境変数を `OPENSEARCH_URL` にリネームし、移行期間中は `ELASTIC_SEARCH_URL` も
   フォールバックとして受け付ける
5. **R5**: `CLAUDE.md` の「CI だけは Elasticsearch 7.17.9 で動く」という記述を実態に合わせる

## 非機能要件 / 制約

- CI の `timeout-minutes: 7` を超えないこと（OpenSearch イメージのビルド時間に注意）
- ローカル開発環境（docker compose）が引き続き動作すること
- 既存の spec を壊さないこと

## スコープ外

- searchkick の設定変更・検索仕様の変更
- OpenSearch のバージョンアップ
