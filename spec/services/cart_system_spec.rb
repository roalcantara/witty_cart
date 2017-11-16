require 'rails_helper'

RSpec.describe CartSystem do
  before do
    create :cart, :with_items, items_count: 2
    create :cart, :with_items, items_count: 3
  end

  describe '.total_pending' do
    subject! { CartSystem.total_pending }

    it 'returns total amount of money pending on the cart system' do
      is_expected.to eq Money.new(Cart.sum(:total_price_cents), Cart.new.total_price_currency).to_f
    end
  end

  describe '.total_of_products' do
    subject! { CartSystem.total_of_products }

    it 'returns how many products are overall in the cart system' do
      is_expected.to eq CartItem.sum(:quantity)
    end
  end
end
