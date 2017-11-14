require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :password }
  end

  describe '#username' do
    let(:user) { create :user, email: 'naruto@leaf.jp' }

    subject! { user.username }

    it { is_expected.to eq 'naruto' }
  end
end
