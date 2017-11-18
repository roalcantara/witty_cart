require 'rails_helper'

RSpec.describe TrackerHelper do
  describe '#track' do
    let(:event_name) { 'ninja' }
    let(:attributes) { { name: 'Naruto', level: 9000.1 } }

    context 'when environment is to be tracked' do
      before { expect(WittyCart).to receive(:tracking?).and_return true }

      it 'tracks an user action' do
        expect(helper).to receive(:content_for).with(:js).and_call_original
        expect(helper).to receive(:track_script).with(event_name, attributes)

        helper.track event_name, attributes
      end
    end

    context 'when environment is NOT to be tracked' do
      before { expect(WittyCart).to receive(:tracking?).and_return false }

      it 'does not track the user`s actions' do
        expect(helper).to_not receive(:content_for).with(:js).and_call_original
        expect(helper).to_not receive(:track_script).with(event_name, attributes)

        helper.track event_name, attributes
      end
    end
  end

  describe '#track_script' do
    subject! { helper.track_script 'ninja', name: 'Naruto', level: 9000.1 }

    it 'renders the tracking script' do
      is_expected.to eq %($(document).on('turbolinks:load', function() {
        WittyCart.tracker.track('ninja', {"name":"Naruto","level":9000.1});
      });
    )
    end
  end
end
