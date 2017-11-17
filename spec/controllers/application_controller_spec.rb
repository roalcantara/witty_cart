require 'rails_helper'

RSpec.describe ApplicationController do
  it_behaves_like 'breadcrumbable'

  context 'when it is a devise controller' do
    controller(ApplicationController) do
      def index
        head :ok
      end
    end

    before { expect(controller).to receive(:devise_controller?).and_return true }

    it 'renders a breadcrumb' do
      get 'index'

      expect(assigns(:breadcrumbs)).to include 'User'
    end
  end
end
