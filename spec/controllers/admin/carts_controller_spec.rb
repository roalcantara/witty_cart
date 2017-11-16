require 'rails_helper'

RSpec.describe Admin::CartsController do
  authenticate :admin

  describe 'GET #index' do
    subject! { get :index, params: {} }

    it { expect(response).to have_http_status :success }
    it { expect(response).to render_template :index }

    it 'assigns all carts as @carts' do
      expect(assigns(:carts)).to include(*Cart.all)
    end
  end

  describe 'GET #show' do
    let!(:cart) { create :cart }

    subject! { get :show, params: { id: cart.to_param } }

    it { expect(response).to have_http_status :success }
    it { expect(response).to render_template :show }

    it 'assigns the requested cart as @cart' do
      expect(assigns(:cart)).to eq cart
    end
  end
end
