FactoryBot.define do
  factory :cart_item do
    cart
    item factory: :product
    quantity { rand 1..20 }
  end
end
