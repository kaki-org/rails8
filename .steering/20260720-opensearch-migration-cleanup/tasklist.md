# タスクリスト: OpenSearch 移行の残作業

- [x] T1: `GEMINI.md` の Elasticsearch 表記を OpenSearch に修正（R1）
- [x] T2: `devenv/elasticsearch/` を `devenv/opensearch/` に `git mv` でリネーム（R2）
- [x] T3: `docker-compose.yml` のサービス名・ボリューム名・Dockerfile パス・env を opensearch に統一（R2, R4）
- [x] T4: `dip.yml` の provision コマンドのサービス名を修正（R2）
- [x] T5: `config/initializers/searchkick.rb` を `OPENSEARCH_URL` 優先 + 旧名フォールバックに（R4）
- [x] T6: `.github/workflows/ruby.yml` の検索バックエンドを OpenSearch に差し替え（R3, R4）
- [x] T7: `CLAUDE.md` の検索エンジン記述を実態に合わせて更新（R5）
- [x] T8: OpenSearch イメージをローカルでビルド・起動し、kuromoji/icu プラグインの導入を確認（検証）
- [x] T9: `bundle exec rubocop` を実行しパスさせる（検証）
- [x] T10: `bundle exec rspec` を実行しパスさせる（検証）
- [x] T11: env 変数の優先順位・フォールバック・デフォルトを実機で検証（T8 実施中に必要と判明し追加）
- [x] T12: implementation-validator の指摘対応（検証後に追加）
  - `Verify OpenSearch plugins` が一覧表示のみでアサートしていなかったため `grep -q` を追加
  - OpenSearch イメージの pull/build がクリティカルパスに乗るため `timeout-minutes` を 7 → 10 に緩和

## 検証ログ（2026-07-20）

| 検証 | 結果 |
|---|---|
| `docker compose config` | OK |
| `actionlint .github/workflows/ruby.yml` | OK |
| `devenv/opensearch/Dockerfile` ビルド + 起動 | health `green` / version `2.18.0` |
| `_cat/plugins` | `analysis-icu`, `analysis-kuromoji` を確認 |
| `docker compose up -d opensearch` | health `green` / プラグイン導入済み |
| `OPENSEARCH_URL` 指定時 | `127.0.0.1:19200` に接続、`ping=true` |
| `OPENSEARCH_URL` 空 + `ELASTIC_SEARCH_URL` 指定 | フォールバック成功、`ping=true` |
| 両方未設定 | `localhost:9200`（従来どおりのデフォルト） |
| `bundle exec rubocop config/initializers/searchkick.rb` | no offenses |
| `bundle exec rspec` | 44 examples, 0 failures, 1 pending |

## 申し送り事項

**実装完了日**: 2026-07-20

### 計画と実績の差分

- Issue の記述が一部古く、`devenv/elasticsearch/Dockerfile` は既に
  `opensearchproject/opensearch:2.18.0` に、`CLAUDE.md` も既に OpenSearch 表記に
  修正済みだった。実作業はディレクトリ名・CI・env 名・`GEMINI.md` に絞られた。
- 計画外に T11 を追加。`ENV.fetch(...) || ENV.fetch(...)` だと **空文字**の
  `OPENSEARCH_URL` がフォールバックを潰し、`hosts=[]` の接続先ゼロのクライアントが
  出来ることを実機検証で発見したため、`.presence` を挟んだ。

### 学んだこと

- 「env 変数を渡すだけ」の変更でも、空文字と未設定の差でクライアントの挙動が変わる。
  Ruby では空文字が truthy なので `||` フォールバックは `.presence` とセットで書く。
- OpenSearch 公式イメージは analysis-kuromoji / analysis-icu を**同梱していない**。
  `searchkick language: 'japanese'` があるため、CI で素の公式イメージに差し替えると
  spec が落ちる。ローカルと同じ Dockerfile をビルドして使う方針にした。

### 開発者向け移行手順（要周知）

compose のサービス名・ボリューム名が `elasticsearch` → `opensearch` に変わったため、
既存環境では旧コンテナが orphan として残り 9200 番ポートを掴んだままになる。
一度だけ以下を実行すること:

```
docker compose down --remove-orphans
docker compose up -d db redis opensearch
```

ボリュームも別名になるため検索インデックスは失われる。`bin/rails searchkick:reindex`
または `rails db:seed` で再生成する。

### 次回への改善提案

- `ELASTIC_SEARCH_URL` フォールバックは移行期間限定。周知後に別 PR で削除する。
- 検索機能を実際に叩く spec が無く（`spec/requests/welcome_spec.rb` のみが関連）、
  CI で OpenSearch が壊れても検知できない。検索の request spec 追加を検討する。
