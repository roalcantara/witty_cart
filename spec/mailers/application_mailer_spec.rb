require 'rails_helper'

RSpec.describe ApplicationMailer do
  it { expect(described_class.ancestors).to include ActionMailer::Base }
end
