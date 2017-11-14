require 'rails_helper'

RSpec.describe ApplicationRecord do
  it { expect(described_class.ancestors).to include ActiveRecord::Base }

  describe '.pluralized_model_name' do
    it 'pluralizes its model name' do
      expect(User.pluralized_model_name).to eq 'Users'
    end
  end
end
