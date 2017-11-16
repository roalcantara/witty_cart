module CartExpirable
  extend ActiveSupport::Concern

  included do
    before_action :expires_the_cart!, if: -> { current_user.cart&.expired? },
                                      unless: -> { current_user.admin? }

    def expires_the_cart!
      current_user.cart.expire!

      redirect_to products_path, flash: { cart_expired: 'Your cart has expired! :(' }
    end
  end
end
