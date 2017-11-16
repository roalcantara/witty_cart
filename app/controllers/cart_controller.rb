class CartController < ApplicationController
  include CartExpirable

  before_action :set_cart, only: %i(index checkout fix_diffs)
  before_action :add_breadcrumbs

  def index; end

  def checkout
    @cart.items.destroy_all

    respond_with @cart, location: cart_index_path, notice: 'Fantabolastic Thanks! 🖖🏼'
  end

  def fix_diffs
    @cart.fix_differs!

    respond_with @cart, location: cart_index_path, notice: 'Your WittyCart has been updated! Check it out! 🤗'
  end

  private

  def set_cart
    @cart = current_user.cart
  end

  def add_breadcrumbs
    add_breadcrumb Cart.model_name.human
  end
end
