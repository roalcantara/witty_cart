require 'rails_helper'

RSpec.describe CartController do
  authenticate :user

  let!(:cart) { @current_user.cart }

  describe 'GET #index' do
    subject! { get :index }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template :index }

    it 'assigns the requested cart as @cart' do
      expect(assigns(:cart)).to eq cart
    end
  end
end
