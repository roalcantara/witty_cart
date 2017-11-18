require 'spec_helper'

RSpec.describe Authenticable do
  after { User.current = nil }

  controller(ApplicationController) do
    include Authenticable

    def index
      head user_signed_in? ? :ok : :bad_request
    end
  end

  describe '#set_current_user' do
    context 'when user signs in' do
      let(:user) { create :user }
      before { sign_in user }

      it 'sets the User.current' do
        get :index

        expect(User.current).to eq user
      end
    end
  end
end
