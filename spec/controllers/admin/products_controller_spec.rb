require 'rails_helper'

RSpec.describe Admin::ProductsController do
  authenticate :admin

  let(:valid_attributes) { attributes_for :product }
  let(:invalid_attributes) { attributes_for :product, name: nil }
  let!(:product) { create :product }

  describe 'GET #index' do
    subject! { get :index }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template :index }

    it 'assigns all users as @products' do
      expect(assigns(:products)).to include(*Product.all)
    end
  end

  describe 'GET #new' do
    subject! { get :new }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template :new }

    it 'assigns a new product as @product' do
      expect(assigns(:product)).to be_a_new Product
    end
  end

  describe 'POST #create' do
    it 'creates a new Product' do
      expect do
        post :create, params: { product: attributes_for(:product) }
      end.to change(Product, :count).by 1
    end

    let(:attributes) { valid_attributes }
    subject! { post :create, params: { product: attributes } }

    context 'with valid params' do
      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admin_product_path(Product.last) }
    end

    context 'with invalid params' do
      let(:attributes) { invalid_attributes }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to render_template :new }

      it 'assigns a newly created but unsaved product as @product' do
        expect(assigns(:product)).to be_a_new Product
      end
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

  describe 'GET #edit' do
    subject! { get :edit, params: { id: product.to_param } }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template :edit }

    it 'assigns the requested product as @product' do
      expect(assigns(:product)).to eq(product)
    end
  end

  describe 'PUT #update' do
    let(:attributes) { valid_attributes }
    subject! { put :update, params: { id: product.to_param, product: attributes } }

    context 'with valid params' do
      let(:attributes) { valid_attributes }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admin_product_path(product) }

      it 'updates the requested product' do
        expect(product.reload.name).to eq valid_attributes[:name]
      end

      it 'assigns the requested product as @product' do
        expect(assigns(:product)).to eq product
      end
    end

    context 'with invalid params' do
      let(:attributes) { invalid_attributes }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to render_template :edit }

      it 'assigns the product as @product' do
        expect(assigns(:product)).to eq product
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested product' do
      expect do
        delete :destroy, params: { id: product.to_param }
      end.to change(Product, :count).by(-1)
    end

    context 'when a product is destroyed' do
      subject! { delete :destroy, params: { id: product.to_param } }

      it { is_expected.to redirect_to admin_products_path }
    end
  end
end
