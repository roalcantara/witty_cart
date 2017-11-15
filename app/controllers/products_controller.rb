class ProductsController < ApplicationController
  before_action :set_product, only: %i(show)
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

  def add_breadcrumbs
    add_breadcrumb Product
    add_breadcrumb @product.to_s if @product
  end
end
