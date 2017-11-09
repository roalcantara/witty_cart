require 'rails_helper'

RSpec.describe ApplicationJob do
  it { expect(described_class.ancestors).to include ActiveJob::Base }
end
