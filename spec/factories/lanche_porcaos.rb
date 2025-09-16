FactoryBot.define do
  factory :lanche_porcao do
    association :lanch
    association :porcao
    quantidade { 1 }

    trait :dupla do
      quantidade { 2 }
    end

    trait :tripla do
      quantidade { 3 }
    end
  end
end
