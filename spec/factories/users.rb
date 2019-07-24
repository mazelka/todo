FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    username { FFaker::Internet.user_name + FFaker::Internet.user_name }
    password { FFaker::Internet.password }
  end
end
