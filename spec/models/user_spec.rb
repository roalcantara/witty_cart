require 'rails_helper'

RSpec.describe User do
  it { expect(User.ancestors).to include Signinable }

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :password }
  end

  describe 'associations' do
    it { is_expected.to have_one(:cart).with_foreign_key :owner_id }
  end

  describe '#username' do
    let(:user) { create :user, email: 'naruto@leaf.jp' }

    subject! { user.username }

    it { is_expected.to eq 'naruto' }
  end

  describe '#firt_name' do
    let(:user) { create :user, name: 'Uzimaki Naruto' }

    subject! { user.first_name }

    it { is_expected.to eq 'Uzimaki' }

    context 'when name is nil' do
      let(:user) { build :user, name: nil }

      it 'returns the username' do
        is_expected.to eq user.username
      end
    end

    context 'when user has no second name' do
      let(:user) { build :user, name: 'Uzimaki' }

      it { is_expected.to eq 'Uzimaki' }
    end
  end

  describe 'callbacks' do
    describe '.after_save' do
      describe '#create_cart!' do
        context 'when admin' do
          let(:user) { build :admin }
          before { user.save }

          it 'does not do anything' do
            expect(user.cart).to be_nil
          end
        end

        context 'when saving' do
          let(:user) { build :user }
          before { user.save }

          subject! { user.cart }

          it { expect(subject).to be_persisted }
          it { expect(subject.owner).to eq user }
        end

        context 'when creating a new user' do
          let(:user) { build :user }

          it 'creates the user`s cart' do
            expect do
              user.save
            end.to change(Cart, :count).by 1
          end
        end

        context 'when updating an user that already have a cart' do
          let!(:user) { create :user }

          it 'does not create a new user`s cart' do
            expect do
              user.update_attribute :email, FFaker::Internet.email
            end.to change(Cart, :count).by 0
          end
        end
      end
    end

    describe 'after create' do
      describe '#track_sign_up' do
        let(:user) { build :user }

        it 'tracks the user sign up event' do
          expect(Woopra::TrackerService).to receive(:track_sign_up).with user

          user.save
        end
      end
    end
  end
end
