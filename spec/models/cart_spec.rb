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

  describe '#differs' do
    let(:cart) { create :cart, :with_items, items_count: 3 }
    let(:cart_item_0) { cart.items[0] }
    let(:cart_item_0_new_price) { Money.new(cart_item_0.item.price.to_f - 2.99, cart_item_0.total_price_currency).to_f }
    let(:cart_item_1) { cart.items[1] }
    let(:cart_item_2) { cart.items[2] }
    let(:cart_item_2_new_price) { Money.new(cart_item_2.item.price.to_f - 2.99, cart_item_2.total_price_currency).to_f }

    before do
      cart_item_0.item.update_attribute(:price, cart_item_0_new_price)
      cart_item_2.item.update_attribute(:price, cart_item_2_new_price)
    end

    subject! { cart.differs }

    it 'returns the products that have their prices changed' do
      is_expected.to include cart_item_0, cart_item_2
    end

    it 'does not return products that haven`t had their prices changed' do
      is_expected.to_not include cart_item_1
    end
  end

  describe '#fix_differs!' do
    let(:cart) { create :cart, :with_items, items_count: 3 }
    let(:cart_item_0) { cart.items[0] }
    let(:cart_item_0_new_price) { Money.new(cart_item_0.item.price.to_f - 2.99, cart_item_0.total_price_currency).to_f }
    let(:cart_item_1) { cart.items[1] }
    let(:cart_item_2) { cart.items[2] }
    let(:cart_item_2_new_price) { Money.new(cart_item_2.item.price.to_f - 2.99, cart_item_2.total_price_currency).to_f }

    before do
      cart_item_0.item.update_attribute(:price, cart_item_0_new_price)
      cart_item_2.item.update_attribute(:price, cart_item_2_new_price)
    end

    subject! { cart.fix_differs! }

    it 'updates the cart items setting the new item price' do
      expect(cart.differs).to be_empty
    end
  end

  describe '#expires_at' do
    let(:cart) { create :cart }

    context 'when the cart has never been updated' do
      subject! { cart.expires_at }

      it 'returns the created day + 2 days' do
        is_expected.to eq cart.created_at + 2.days
      end
    end

    context 'when the cart has already been updated' do
      before { cart.touch }

      subject! { cart.expires_at }

      it 'returns the updated day + 2 days' do
        is_expected.to eq cart.updated_at + 2.days
      end
    end
  end

  describe '#expired?' do
    subject(:cart) { create :cart }

    context 'when the cart has no items' do
      it { is_expected.to_not be_expired }
    end

    context 'when the cart has items' do
      before { create :cart_item, cart_id: cart.id }

      context 'when the current day is BEFORE than expires_at' do
        it do
          travel_to(cart.expires_at - 1) do
            is_expected.to_not be_expired
          end
        end
      end

      context 'when the current day is AFTER than expires_at' do
        it do
          travel_to((cart.expires_at + 2.days)) do
            is_expected.to be_expired
          end
        end
      end
    end
  end

  describe '#expire!' do
    let(:cart) { create :cart }

    context 'when the cart has items' do
      before { create :cart_item, cart_id: cart.id }

      it do
        expect do
          cart.expire!
        end.to change(cart.items, :count).to(0)
      end
    end
  end
end
