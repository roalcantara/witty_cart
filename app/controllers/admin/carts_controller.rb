module Admin
  class CartsController < ApplicationController
    before_action :set_cart, only: %i(show)
    before_action :add_breadcrumbs

    def index
      @carts = Cart.all.order :id
    end

    def show; end

    def set_cart
      @cart = Cart.find params[:id]
    end

    private

    def add_breadcrumbs
      add_breadcrumb Cart
      add_breadcrumb @cart.to_s if @cart
    end
  end
end
