FactoryBot.define do
  factory :compra do
    association :item
    nome { item&.nome || Faker::Food.ingredient }
    preco { Faker::Commerce.price(range: 5.0..50.0) }
    peso { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    data_compra { Faker::Date.between(from: 30.days.ago, to: Date.current) }

    trait :cara do
      preco { Faker::Commerce.price(range: 80.0..150.0) }
    end

    trait :barata do
      preco { Faker::Commerce.price(range: 1.0..10.0) }
    end

    trait :recente do
      data_compra { Faker::Date.between(from: 7.days.ago, to: Date.current) }
    end

    trait :antiga do
      data_compra { Faker::Date.between(from: 90.days.ago, to: 30.days.ago) }
    end
  end
end
