require 'rails_helper'

RSpec.describe Woopra::TrackerJob do
  describe '#perform' do
    let(:configuration) do
      {
        domain: 'mydomain.com',
        cookie_domain: 'mydomain.com',
        ip_address: '127.0.0.1',
        cookie_value: 'cookie',
        user_agent: '',
        url: 'http://localhost'
      }
    end
    let(:user) { create :user }
    let(:event_name) { 'sign_up' }
    let(:properties) do
      {
        email: user.email
      }
    end
    let(:woopra) { spy('woopra') }

    before { allow(Woopra::Tracker).to receive(:new).with(configuration).and_return woopra }

    subject! { described_class.new.perform configuration, user.id, event_name, properties }

    it 'sets the domain correctly' do
      expect(woopra).to have_received(:config).with domain: WittyCart.woopra_domain
    end

    it 'identifies the user' do
      expect(woopra).to have_received(:identify).with(id: user.id, name: user.name, email: user.email)
    end

    it 'tracks the custom event' do
      expect(woopra).to have_received(:track).with event_name, properties, true
    end
  end
end
