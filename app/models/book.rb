class Book < ApplicationRecord
  default_scope -> { order("published_on desc") }
  scope :costly, -> { where("price > ?", 3000)}
  scope :written_about, ->(theme) { where("name like ?", "%#{theme}%") }
  scope :find_price, ->(price) { find_by(price: price) } # NOTE: find_byがnilを返してしまう為、条件を指定していないのと同じになってしまう
end
