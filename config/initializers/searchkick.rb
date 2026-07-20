# frozen_string_literal: true

# 接続先は OpenSearch。ELASTIC_SEARCH_URL は移行期間の互換用フォールバックで、
# いずれ削除する。どちらも未設定なら opensearch-ruby のデフォルト
# (http://localhost:9200) が使われる。
# 空文字を渡すと接続先ゼロ (hosts=[]) のクライアントが出来てしまうため presence で弾く。
Searchkick.client = OpenSearch::Client.new(
  url: ENV.fetch('OPENSEARCH_URL', nil).presence || ENV.fetch('ELASTIC_SEARCH_URL', nil).presence
)
