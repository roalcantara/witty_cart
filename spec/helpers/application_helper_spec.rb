require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#current_year' do
    subject! { helper.current_year }

    it 'returns the current year' do
      is_expected.to eq Date.current.year
    end
  end
end
