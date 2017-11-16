require 'rails_helper'

RSpec.describe CartItemsController do
  authenticate :user

  it { expect(CartController.ancestors).to include CartExpirable }

  let!(:cart) { @current_user.cart }
  let!(:product) { create :product }
  let!(:cart_item) { create :cart_item, cart_id: cart.id }

  describe 'POST #create' do
    it 'adds an item to the current_user`s cart' do
      expect do
        post :create, params: { cart_item: attributes_for(:cart_item, item_id: product.id) }
      end.to change(CartItem, :count).by 1
    end

    let(:attributes) { attributes_for(:cart_item, item_id: product.id) }
    subject! { post :create, params: { cart_item: attributes } }

    context 'with valid params' do
      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to cart_index_path }

      it 'assigns the current_user`s cart as @cart' do
        expect(assigns(:cart)).to eq cart
      end
    end

    context 'with invalid params' do
      let(:attributes) { attributes_for(:cart_item, item_id: nil) }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to cart_index_path }

      it 'assigns the current_user`s cart as @cart' do
        expect(assigns(:cart)).to eq cart
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when an item is removed from the current_user`s cart' do
      it 'destroies the cart_item' do
        expect do
          delete :destroy, params: { id: cart_item.to_param }
        end.to change(CartItem, :count).by(-1)
      end
    end

    context 'when a cart_item is destroyed' do
      subject! { delete :destroy, params: { id: cart_item.to_param } }

      it { is_expected.to redirect_to cart_index_path }
    end
  end
end
