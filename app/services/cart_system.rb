class CartSystem
  def self.total_pending
    Money.new(Cart.sum(:total_price_cents), Cart.new.total_price_currency).to_f
  end

  def self.total_of_products
    CartItem.sum :quantity
  end
end
