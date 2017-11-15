require 'rails_helper'

RSpec.describe Product do
  describe 'validations' do
    subject { build :product }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

    it { is_expected.to monetize :price }
    it do
      is_expected.to validate_numericality_of(:price)
        .is_greater_than_or_equal_to 0.0
    end
  end
end
