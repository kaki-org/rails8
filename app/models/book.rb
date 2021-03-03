class Book < ApplicationRecord
  default_scope -> { order("published_on desc") } # NOTE これはよく使う手ではあるけど非推奨。unscopedで打ち消せる。
  scope :costly, -> { where("price > ?", 3000) }
  scope :written_about, ->(theme) { where("name like ?", "%#{theme}%") }
  scope :find_price, ->(price) { find_by(price: price) } # NOTE: find_byがnilを返してしまう為、条件を指定していないのと同じになってしまう

  belongs_to :publisher
  has_many :book_authors
  has_many :authors, through: :book_authors

  validates :name, presence: true
  validates :name, length: { maximum: 25 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validate do |book|
    if book.name.include?("exercise")
      book.errors.add(:name, "I don't like exercise.")
    end
  end
  # before_validation do
  #   self.name = self.name.gsub(/Cat/) do |matched|
  #     "lovely #{matched}"
  #   end
  # end
  # あるいはメソッドを使って以下のようにかける
  before_validation :add_lovely_to_cat
  def add_lovely_to_cat
    self.name = self.name.gsub(/Cat/) do |matched|
      "lovely #{matched}"
    end
  end
  after_destroy do
    Rails.logger.info "Book is deleted: #{self.attributes}"
  end
  after_destroy :if => :high_price? do
    Rails.logger.warn "Book with high price is deleted: #{self.attributes}"
    Rails.logger.warn "Please check!!"
  end

  def high_price?
    price >= 5000
  end

  # ActiveRecord::Enumを利用してみる(今はenumerize gemがいいかもしれない)
  # RESERVATION = 0  #予約受付
  # NOW_ON_SALE = 1  #発売中
  # END_OF_PRINT = 2 #販売終了
  # SALES_STATUS = [RESERVATION, NOW_ON_SALE, END_OF_PRINT]
  enum sales_status: {
    reservation: 0, #予約受け付け
    now_on_sale: 1, #発売中
    end_of_print: 2, #販売終了
  }
end
