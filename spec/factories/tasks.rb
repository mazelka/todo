FactoryBot.define do
  factory :task do
    name { FFaker::Product.brand }
    deadline { nil }
    position { nil }
    done { false }
    project
  end
end
