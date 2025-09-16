require 'rails_helper'

RSpec.describe LanchePorcao, type: :model do
  describe 'associations' do
    it { should belong_to(:lanch) }
    it { should belong_to(:porcao) }
  end

  describe 'attributes' do
    it 'has default quantidade of 1' do
      lanche_porcao = build(:lanche_porcao)
      expect(lanche_porcao.quantidade).to eq 1
    end
  end

  describe 'factory' do
    it 'creates a valid lanche_porcao' do
      lanche_porcao = build(:lanche_porcao)
      expect(lanche_porcao).to be_valid
    end

    it 'creates a dupla quantidade with trait' do
      lanche_porcao = build(:lanche_porcao, :dupla)
      expect(lanche_porcao.quantidade).to eq 2
    end

    it 'creates a tripla quantidade with trait' do
      lanche_porcao = build(:lanche_porcao, :tripla)
      expect(lanche_porcao.quantidade).to eq 3
    end
  end

  describe 'relationship validation' do
    it 'requires both lanch and porcao' do
      lanche_porcao = build(:lanche_porcao, lanch: nil, porcao: nil)
      expect(lanche_porcao).not_to be_valid
    end
  end
end
