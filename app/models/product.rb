class Product < ApplicationRecord
  monetize :price_cents, numericality: {
    greater_than_or_equal_to: 0.0
  }, allow_nil: false

  validates :price, presence: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
