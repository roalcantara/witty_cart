class CartItem < ApplicationRecord
  belongs_to :cart, optional: false, touch: true
  belongs_to :item, class_name: 'Product', optional: false
  monetize :unit_price_cents, numericality: {
    greater_than_or_equal_to: 0.0
  }, allow_nil: false
  monetize :total_price_cents, numericality: {
    greater_than_or_equal_to: 0.0
  }, allow_nil: false

  validates :cart, :item, :quantity, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  before_save :set_price

  def update_price!
    set_price
    save!
  end

  private

  def set_price
    self.unit_price = item.price if item.present?
    self.total_price = Money.new(quantity * item&.price, total_price_currency)
  end
end
