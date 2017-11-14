require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#current_year' do
    subject! { helper.current_year }

    it 'returns the current year' do
      is_expected.to eq Date.current.year
    end
  end

  describe '#error?' do
    let(:resource) { build :user }

    before { resource.valid? }

    subject! { helper.error? resource, :email }

    context 'when the resource`s field has no errors' do
      it { is_expected.to be_nil }
    end

    context 'when the resource`s field has any error' do
      let(:resource) { build :user, email: nil }

      it { is_expected.to eq 'is-invalid' }
    end
  end

  describe '#error' do
    let(:resource) { build :user }

    before { resource.valid? }

    subject! { helper.error resource, :email }

    context 'when the resource`s field has no errors' do
      it { is_expected.to be_nil }
    end

    context 'when the resource`s field has any error' do
      let(:resource) { build :user, email: nil }

      it 'renders a `invalid-feedback` div' do
        is_expected.to include 'invalid-feedback d-block mt-0'
      end

      it 'renders a the error message' do
        is_expected.to include resource.errors[:email].join(', ')
      end
    end
  end
end
