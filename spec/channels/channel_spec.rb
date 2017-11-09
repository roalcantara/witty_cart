require 'rails_helper'

RSpec.describe ApplicationCable::Channel do
  it { expect(described_class.ancestors).to include ActionCable::Channel::Base }
end
