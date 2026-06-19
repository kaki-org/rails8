# frozen_string_literal: true

Searchkick.client = OpenSearch::Client.new(url: ENV['ELASTIC_SEARCH_URL'])
