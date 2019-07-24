FactoryBot.define do
  factory :project do
    name { FFaker::Company.name }
    user
  end
end
