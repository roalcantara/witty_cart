require 'rails_helper'

RSpec.describe Cart do
  describe 'associations' do
    it { is_expected.to belong_to(:owner).class_name 'User' }
    it { is_expected.to have_many(:items).class_name 'CartItem' }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :owner }
    it { is_expected.to monetize :total_price }
    it do
      is_expected.to validate_numericality_of(:total_price)
        .is_greater_than_or_equal_to 0.0
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:count).to(:items).with_prefix true }
  end

  describe '#quantity_of_products' do
    let(:item_1) { build :cart_item, quantity: 2 }
    let(:item_2) { build :cart_item, quantity: 3 }
    let(:cart) { create :cart, items: [item_1, item_2] }

    subject! { cart.quantity_of_products }

    it 'returns how many products are in the cart' do
      is_expected.to eq 5
    end

    context 'when there are no items' do
      let(:cart) { create :cart }

      it { is_expected.to be_zero }
    end
  end

  describe 'callbacks' do
    describe '.before_save' do
      describe '#set_price' do
        let(:item_1) { build :cart_item, quantity: 1 }
        let(:item_2) { build :cart_item, quantity: 2 }
        let(:cart) { build :cart, items: [item_1, item_2] }

        context 'sets the total price' do
          before { cart.save! }
          subject! { cart.total_price.to_f }

          it { is_expected.to eq Money.new(cart.items.sum(:total_price_cents), item_1.total_price_currency).to_f }
        end
      end
    end
  end
end
