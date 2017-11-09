require 'rails_helper'

RSpec.describe ApplicationRecord do
  it { expect(described_class.ancestors).to include ActiveRecord::Base }
end
