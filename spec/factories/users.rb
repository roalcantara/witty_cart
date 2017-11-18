FactoryBot.define do
  factory :user do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
    password_confirmation { password }

    factory :admin do
      admin true
    end
  end
end
