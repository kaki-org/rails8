class Book < ApplicationRecord
  default_scope -> { order("published_on desc") } # NOTE これはよく使う手ではあるけど非推奨。unscopedで打ち消せる。
  scope :costly, -> { where("price > ?", 3000)}
  scope :written_about, ->(theme) { where("name like ?", "%#{theme}%") }
  scope :find_price, ->(price) { find_by(price: price) } # NOTE: find_byがnilを返してしまう為、条件を指定していないのと同じになってしまう

  belongs_to :publisher
  has_many :book_authors
  has_many :authors, through: :book_authors
end
