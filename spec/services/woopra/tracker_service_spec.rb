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
end
