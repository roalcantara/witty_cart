require 'rails_helper'

RSpec.describe ApplicationCable::Connection do
  it { expect(described_class.ancestors).to include ActionCable::Connection::Base }
end
