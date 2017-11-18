require 'rails_helper'

RSpec.describe Woopra::TrackerService do
  let(:configuration) { { domain: 'localhost' } }
  let(:current_time) { DateTime.current }
  let!(:user) { create :user }

  before do
    allow(Woopra::Tracker).to receive(:current_configuration).and_return configuration
    travel_to current_time
    User.current = user
  end
  after { travel_back }

  describe '.track_sign_up' do
    it 'enqueues a Tracker Job' do
      expect do
        described_class.track_sign_up user
      end.to have_enqueued_job(Woopra::TrackerJob).once.with configuration,
                                                             user.id,
                                                             'sign_up',
                                                             id: user.id,
                                                             name: user.name,
                                                             email: user.email,
                                                             admin: user.admin?
    end
  end

  describe '.track_sign_in' do
    it 'enqueues a Tracker Job' do
      expect do
        described_class.track_sign_in user
      end.to have_enqueued_job(Woopra::TrackerJob).once.with configuration,
                                                             user.id,
                                                             'sign_in',
                                                             id: user.id,
                                                             name: user.name,
                                                             email: user.email,
                                                             admin: user.admin?
    end
  end

  describe '.track_add_to_cart' do
    let(:cart_item) { create :cart_item }

    it 'enqueues a Tracker Job' do
      expect do
        described_class.track_add_to_cart cart_item
      end.to have_enqueued_job(Woopra::TrackerJob).once.with configuration,
                                                             user.id,
                                                             'add_to_cart',
                                                             product_id: cart_item.item.id,
                                                             product: cart_item.item.name,
                                                             quantity: cart_item.quantity,
                                                             price: cart_item.total_price.to_f
    end
  end

  describe '.track_checkout' do
    it 'enqueues a Tracker Job' do
      expect do
        described_class.track_checkout user
      end.to have_enqueued_job(Woopra::TrackerJob).once.with configuration,
                                                             user.id,
                                                             'checkout',
                                                             quantity: user.cart.quantity_of_products,
                                                             price: user.cart.total_price.to_f
    end
  end
end
