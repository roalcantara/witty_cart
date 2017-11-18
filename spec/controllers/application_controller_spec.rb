require 'rails_helper'

RSpec.describe ApplicationController do
  it_behaves_like 'breadcrumbable'

  context 'when it is a devise controller' do
    controller(ApplicationController) do
      def index
        head :ok
      end
    end

    before do
      expect(controller).to receive(:devise_controller?).twice.and_return true
      expect(controller).to receive(:configure_permitted_parameters)
    end

    it 'renders a breadcrumb' do
      get 'index'

      expect(assigns(:breadcrumbs)).to include 'User'
    end
  end
end
