require 'rails_helper'

RSpec.describe DeviseHelper do
  describe '#devise_error_messages!' do
    let(:resource) { build :user }

    before { resource.valid? }

    context 'when resource has no error messages' do
      it 'does not render the toast with the error messages' do
        devise_error_messages!
      end
    end

    context 'when resource has error messages' do
      let(:resource) { build :user, email: nil }
      def toast(message, type: :error); end

      it 'renders a toast with all the errors messages' do
        devise_error_messages!
      end
    end
  end
end
