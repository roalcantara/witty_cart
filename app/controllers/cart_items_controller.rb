class CartItemsController < ApplicationController
  include CartExpirable

  before_action :set_cart
  before_action :set_cart_item, only: %i(destroy)
  before_action :set_product, only: %i(create)
  before_action :add_breadcrumbs

  def create
    @cart_item = @cart.items.create(cart_item_params)

    if @cart_item.errors.any?
      render 'products/show'
    else
      Woopra::TrackerService.track_add_to_cart(@cart_item)
      redirect_to products_path, notice: 'An item has been added! YAY!'
    end
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

  def set_product
    @product = Product.find params[:cart_item][:item_id]
  end

  def set_cart_item
    @cart_item = @cart.items.find params[:id]
  end

  def add_breadcrumbs
    if params[:action] == 'create'
      add_breadcrumb Product
      add_breadcrumb @product.to_s if @product
    else
      add_breadcrumb Cart.model_name.human
    end
  end
end
