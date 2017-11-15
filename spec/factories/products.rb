FactoryBot.define do
  factory :product do
    sequence(:name) { |n| [FFaker::Product.product_name, n].join('_') }
    price { rand(24.99..9001.00) }
  end
end
