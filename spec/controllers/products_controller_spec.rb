require 'rails_helper'

RSpec.describe ProductsController do
  authenticate :user

  it { expect(ProductsController.ancestors).to include CartExpirable }

  let!(:product) { create :product }

  describe 'GET #index' do
    subject! { get :index }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template :index }

    it 'assigns all users as @products' do
      expect(assigns(:products)).to include(*Product.all)
    end
  end

  describe 'GET #show' do
    subject! { get :show, params: { id: product.to_param } }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template :show }

    it 'assigns the requested product as @product' do
      expect(assigns(:product)).to eq product
    end
  end
end
