require 'rails_helper'

RSpec.describe CartExpirable do
  controller(ApplicationController) do
    include CartExpirable

    def index
      head :ok
    end
  end

  context 'when user is an admin?' do
    authenticate :admin

    subject! { get :index }

    it { is_expected.to_not redirect_to products_path }
  end

  context 'when user is an user' do
    authenticate :user

    before do
      create :cart_item, cart_id: @current_user.cart.id
    end

    context 'with an expired cart' do
      before do
        @current_user.cart.update_column :updated_at, (Date.current - 3.days)
      end

      it 'expires the cart' do
        expect do
          get :index
        end.to change(@current_user.cart.items, :count).from(1).to(0)
      end

      context 'when the cart is expired' do
        subject! { get :index }

        it { is_expected.to redirect_to products_path }
      end
    end

    context 'with no expired cart' do
      it 'does not expire the cart' do
        expect do
          get :index
        end.to change(@current_user.cart.items, :count).by(0)
      end

      context 'when the cart is NOT expired' do
        subject! { get :index }

        it { is_expected.to_not redirect_to products_path }
      end
    end
  end
end
