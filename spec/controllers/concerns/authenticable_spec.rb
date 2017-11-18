require 'spec_helper'

RSpec.describe Authenticable do
  after { User.current = nil }

  describe 'devise extra parameter treatment' do
    context 'when it is a devise controller' do
      controller(DeviseController) do
        include Authenticable

        def index
          head :ok
        end
      end

      before { @request.env['devise.mapping'] = Devise.mappings[:user] }

      it 'sets the sanitizer parameters' do
        ApplicationController::DEVISE_SANITIZER_ACTIONS.each do |controller|
          expect(subject.devise_parameter_sanitizer).to receive(:permit)
            .with(controller, keys: ApplicationController::DEVISE_EXTRA_RESOURCE_PARAMS).once
        end

        get :index
      end
    end

    context 'when it is not a devise controller' do
      controller(ApplicationController) do
        include Authenticable

        def index
          head :ok
        end
      end

      it "doesn't call configure_permitted_parameters" do
        expect(subject).not_to receive(:configure_permitted_parameters)

        get :index
      end
    end
  end

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
