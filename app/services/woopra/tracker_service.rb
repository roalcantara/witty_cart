module Woopra
  class TrackerService
    def self.track(event_name, properties = {}, user_id = User.current&.id)
      TrackerJob.perform_later Tracker.current_configuration,
                               user_id,
                               event_name.to_s,
                               properties
    end

    def self.track_sign_up(user)
      track :sign_up, {
        id: user.id,
        name: user.name,
        email: user.email,
        admin: user.admin?
      }, user.id
    end

    def self.track_sign_in(user)
      track :sign_in, {
        id: user.id,
        name: user.name,
        email: user.email,
        admin: user.admin?
      }, user.id
    end

    def self.track_add_to_cart(cart_item)
      track :add_to_cart,
            product_id: cart_item.item.id,
            product: cart_item.item.name,
            quantity: cart_item.quantity,
            price: cart_item.total_price.to_f
    end

    def self.track_checkout(cart)
      track :checkout,
            quantity: cart.quantity_of_products,
            price: cart.total_price.to_f
    end

    def self.track_remove_from_cart(cart_item)
      track :remove_from_cart,
            product_id: cart_item.item.id,
            product: cart_item.item.name,
            quantity: cart_item.quantity,
            price: cart_item.total_price.to_f
    end

    private_class_method :track
  end
end
