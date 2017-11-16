class CartController < ApplicationController
  before_action :set_cart, only: %i(index checkout)
  before_action :add_breadcrumbs

  def index; end

  private

  def set_cart
    @cart = current_user.cart
  end

  def add_breadcrumbs
    add_breadcrumb Cart.model_name.human
  end
end
