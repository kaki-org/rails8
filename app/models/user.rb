class User < ApplicationRecord
  validates :name, presence: true
  has_one_attached :portrait
end
