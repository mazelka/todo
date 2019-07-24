FactoryBot.define do
  factory :task do
    name { FFaker::Product.brand }
    deadline { Time.now }
    position { nil }
    done { false }
    project
  end
end
