FactoryBot.define do
  factory :porcao do
    association :item
    peso_utilizado { rand(0.1..2.0).round(3) }
    nome { "#{Faker::Food.ingredient} - #{peso_utilizado}kg" }

    trait :pequena do
      peso_utilizado { rand(0.05..0.2).round(3) }
    end

    trait :media do
      peso_utilizado { rand(0.2..0.5).round(3) }
    end

    trait :grande do
      peso_utilizado { rand(0.5..1.0).round(3) }
    end
  end
end
