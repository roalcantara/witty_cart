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

  describe 'PUT #fix_diffs' do
    context 'when the cart has items that have their price updated' do
      let(:cart_item_0) { create :cart_item, cart_id: cart.id }
      let(:cart_item_0_new_price) do
        Money.new(cart_item_0.item.price.to_f - 2.99, cart_item_0.total_price_currency).to_f
      end

      before do
        cart_item_0.save
        cart_item_0.item.update_attribute(:price, cart_item_0_new_price)
      end

      subject! { post :fix_diffs }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to cart_index_path }

      it 'assigns the requested cart as @cart' do
        expect(assigns(:cart)).to eq cart
      end

      it 'resolves all the cart`s differed items' do
        expect(assigns(:cart).differs).to be_empty
      end
    end
  end
end
