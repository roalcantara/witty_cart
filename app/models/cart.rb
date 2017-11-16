class Cart < ApplicationRecord
  belongs_to :owner, class_name: 'User', optional: false
  has_many :items, class_name: 'CartItem'
  monetize :total_price_cents, numericality: {
    greater_than_or_equal_to: 0.0
  }, allow_nil: true

  delegate :count, to: :items, prefix: true, allow_nil: true

  validates :owner, presence: true

  after_touch :set_price

  def quantity_of_products
    items.sum :quantity
  end

  private

  def set_price
    update_attributes total_price: Money.new(items.sum(:total_price_cents), total_price_currency)
  end
end
