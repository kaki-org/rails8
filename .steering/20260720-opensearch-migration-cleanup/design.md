# 設計: OpenSearch 移行の残作業

## 変更対象ファイル

| ファイル | 変更内容 | 対応要件 |
|---|---|---|
| `GEMINI.md` | 検索エンジン表記を OpenSearch 2.18.0 + Searchkick に | R1 |
| `devenv/elasticsearch/` → `devenv/opensearch/` | `git mv` でディレクトリリネーム | R2 |
| `docker-compose.yml` | サービス名 / ボリューム名 / `depends_on` / Dockerfile パス / env を opensearch に | R2, R4 |
| `dip.yml` | `provision` の `dip compose up -d db redis elasticsearch` を opensearch に | R2 |
| `.github/workflows/ruby.yml` | ES action を廃止し、devenv の Dockerfile をビルドして OpenSearch を起動 | R3, R4 |
| `config/initializers/searchkick.rb` | `OPENSEARCH_URL` 優先・`ELASTIC_SEARCH_URL` フォールバック | R4 |
| `CLAUDE.md` | CI も OpenSearch になった旨に更新 | R5 |

## 設計判断

### D1: CI の OpenSearch 起動方法

`searchkick language: 'japanese'` が **analysis-kuromoji** プラグインを要求するため、
プラグイン無しの素の公式イメージは使えない。

検討した選択肢:

| 案 | 内容 | 判定 |
|---|---|---|
| A | `devenv/opensearch/Dockerfile` を CI でビルドして `docker run` | **採用** |
| B | `services:` に素の `opensearchproject/opensearch` を指定 | 却下: kuromoji が無く spec が落ちる |
| C | `services:` 起動後にプラグインを後入れ | 却下: プラグイン反映に再起動が必要 |

案 A はローカル開発環境と CI で **同一の Dockerfile** を使うため、
「実装と説明の乖離」という Issue の根本原因を再発させない点でも優れる。

`services:` ブロックを使わないのは、既存コメント（L42「起動数が多すぎるせいか rspec が
動かなくなる」）の経緯を踏襲し、明示的な `docker run` + ヘルスチェック待ちにするため。

### D2: 環境変数のフォールバック

```ruby
Searchkick.client = OpenSearch::Client.new(
  url: ENV.fetch('OPENSEARCH_URL', nil) || ENV.fetch('ELASTIC_SEARCH_URL', nil)
)
```

`OPENSEARCH_URL` を正とし、旧名は移行期間の互換用に残す。
どちらも未設定なら `nil` が渡り、opensearch-ruby のデフォルト
（`http://localhost:9200`）が使われる — 現行挙動と同じ。

### D3: ボリューム名のリネーム

`elasticsearch` ボリュームを `opensearch` にリネームすると既存ローカルボリュームは
参照されなくなる（インデックスは消える）。検索インデックスは `rails searchkick:reindex`
または seed で再生成可能なため許容する。tasklist に開発者向け申し送りを残す。

## 検証方針

1. `docker compose config` で compose 定義の妥当性を確認
2. `devenv/opensearch/Dockerfile` をローカルでビルドし、起動して
   `_cat/plugins` に analysis-kuromoji / analysis-icu が出ることを確認
3. `bundle exec rubocop` / `bundle exec rspec`（検索 spec を含む）を実行
4. `actionlint`（あれば）で workflow 構文を確認
