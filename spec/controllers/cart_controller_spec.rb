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

  describe 'POST #checkout' do
    subject! { post :checkout }

    it { is_expected.to have_http_status :found }
    it { is_expected.to redirect_to cart_index_path }

    it 'assigns the requested cart as @cart' do
      expect(assigns(:cart)).to eq cart
    end

    it 'cleans up all cart`s items' do
      expect(assigns(:cart).items).to be_empty
    end
  end
end
