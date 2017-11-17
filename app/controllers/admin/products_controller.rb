module Admin
  class ProductsController < ApplicationController
    before_action :set_product, only: %i(show edit update destroy)
    before_action :add_breadcrumbs

    def index
      @products = Product.all.order('id DESC')

      respond_with :admin, @products
    end

    def show
      respond_with :admin, @product
    end

    def new
      @product = Product.new

      respond_with :admin, @product
    end

    def edit; end

    def create
      @product = Product.create(product_params)

      respond_with :admin, @product
    end

    def update
      @product.update(product_params)

      respond_with :admin, @product
    end

    def destroy
      @product.destroy

      respond_with :admin, @product
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :price)
    end

    def add_breadcrumbs
      add_breadcrumb Product
      add_breadcrumb @product.to_s if @product
      add_breadcrumb 'New Product' if %w(new create).include?(params[:action])
    end
  end
end
