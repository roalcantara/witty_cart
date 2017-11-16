FactoryBot.define do
  factory :cart do
    owner factory: :user

    trait :with_items do
      transient do
        items_count { 1 }
      end

      after :build do |instance, evaluator|
        instance.items += build_list :cart_item, evaluator.items_count
      end
    end
  end
end
