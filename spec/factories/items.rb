FactoryBot.define do
  factory :item do
    nome { Faker::Food.ingredient }
    preco { Faker::Commerce.price(range: 5.0..50.0) }
    peso { 1.0 }
    categoria { [ 'Proteína', 'Vegetais', 'Condimentos', 'Pães', 'Molhos' ].sample }
    descricao { Faker::Food.description }
    ativo { true }
    disponivel { true }

    trait :inativo do
      ativo { false }
    end

    trait :indisponivel do
      disponivel { false }
    end

    trait :caro do
      preco { Faker::Commerce.price(range: 80.0..150.0) }
    end

    trait :barato do
      preco { Faker::Commerce.price(range: 1.0..10.0) }
    end
  end
end
