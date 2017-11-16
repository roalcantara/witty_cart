class ProductsController < ApplicationController
  include CartExpirable

  before_action :set_product, only: %i(show)
  before_action :set_cart_item, only: %i(show)
  before_action :add_breadcrumbs

  def index
    @products = Product.all.order('id DESC')

    respond_with :admin, @products
  end

  def show
    respond_with :admin, @product
  end

  private

  def set_product
    @product = Product.find params[:id]
  end

  def set_cart_item
    @cart_item = current_user.cart.items.build(item_id: @product.id)
  end

  def add_breadcrumbs
    add_breadcrumb Product
    add_breadcrumb @product.to_s if @product
  end
end
