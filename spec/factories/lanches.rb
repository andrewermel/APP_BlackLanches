FactoryBot.define do
  factory :lanch do
    nome { Faker::Food.dish }
    custo { 0.0 } # Será calculado automaticamente pelos callbacks
    preco_sugerido { 0.0 } # Será calculado automaticamente pelos callbacks
    valor_venda { nil }
    posicao { rand(1..100) }

    trait :com_valor_venda do
      valor_venda { Faker::Commerce.price(range: 15.0..45.0) }
    end

    trait :barato do
      after(:create) do |lanch|
        create_list(:lanche_porcao, 2, lanch: lanch, porcao: create(:porcao, :pequena))
      end
    end

    trait :caro do
      after(:create) do |lanch|
        create_list(:lanche_porcao, 4, lanch: lanch, porcao: create(:porcao, :grande))
      end
    end

    trait :completo do
      after(:create) do |lanch|
        # Cria algumas porções variadas
        create(:lanche_porcao, lanch: lanch, porcao: create(:porcao, :media), quantidade: 1)
        create(:lanche_porcao, lanch: lanch, porcao: create(:porcao, :pequena), quantidade: 2)
        create(:lanche_porcao, lanch: lanch, porcao: create(:porcao, :grande), quantidade: 1)
      end
    end
  end
end
