require 'rails_helper'

RSpec.describe CartItem do
  describe 'associations' do
    it { is_expected.to belong_to :cart }
    it { is_expected.to belong_to(:item).class_name 'Product' }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :cart }
    it { is_expected.to validate_presence_of :item }
    it { is_expected.to validate_presence_of :quantity }
    it { is_expected.to monetize :unit_price }
    it { is_expected.to monetize :total_price }
    it do
      is_expected.to validate_numericality_of(:quantity)
        .only_integer.is_greater_than 0
    end
    it do
      is_expected.to validate_numericality_of(:unit_price)
        .is_greater_than_or_equal_to 0.0
    end
    it do
      is_expected.to validate_numericality_of(:total_price)
        .is_greater_than_or_equal_to 0.0
    end
  end

  describe 'callbacks' do
    describe '.before_save' do
      describe '#set_price' do
        let(:cart_item) { build :cart_item }

        before { cart_item.save }

        it 'sets the unit price' do
          expect(cart_item.unit_price).to eq cart_item.item.price
        end

        it 'sets the total price' do
          expect(cart_item.total_price.to_f)
            .to eq format('%.2f', cart_item.quantity * cart_item.unit_price).to_f
        end
      end
    end
  end
end
