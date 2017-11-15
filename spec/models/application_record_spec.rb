require 'rails_helper'

RSpec.describe ApplicationRecord do
  it { expect(described_class.ancestors).to include ActiveRecord::Base }

  describe '.pluralized_model_name' do
    it 'pluralizes its model name' do
      expect(User.pluralized_model_name).to eq 'Users'
    end
  end

  describe '#to_s' do
    let(:application_record) { build :user, id: 1 }

    subject! { application_record.to_s }

    context 'when the instace has got id' do
      it 'renders the model human name followed by its id' do
        is_expected.to eq 'User #1'
      end
    end

    context 'when the instace has no id' do
      let(:application_record) { build :user }

      it 'renders just the model human name' do
        is_expected.to eq 'User'
      end
    end
  end
end
