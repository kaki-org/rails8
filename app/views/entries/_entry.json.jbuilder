json.extract! entry, :id, :title, :body, :blog.references, :created_at, :updated_at
json.url entry_url(entry, format: :json)
