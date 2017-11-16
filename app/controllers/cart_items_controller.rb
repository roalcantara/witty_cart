class CartItemsController < ApplicationController
  before_action :set_cart
  before_action :set_cart_item, only: %i(destroy)
  before_action :add_breadcrumbs

  def create
    @cart.items.create(cart_item_params)

    redirect_to cart_index_path, notice: 'An item has been added! YAY!'
  end

  def destroy
    @cart_item.destroy

    redirect_to cart_index_path, notice: 'Item has been removed! :('
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:item_id, :quantity)
  end

  def set_cart
    @cart = current_user.cart
  end

  def set_cart_item
    @cart_item = @cart.items.find params[:id]
  end

  def add_breadcrumbs
    add_breadcrumb Cart.model_name.human
  end
end
