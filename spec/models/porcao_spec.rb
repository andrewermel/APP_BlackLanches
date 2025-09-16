require 'rails_helper'

RSpec.describe Porcao, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:nome) }
    it { should validate_length_of(:nome).is_at_least(2).is_at_most(100) }
    it { should validate_presence_of(:peso_utilizado) }
    it { should validate_numericality_of(:peso_utilizado).is_greater_than(0) }
    it { should validate_presence_of(:item_id) }
  end

  describe 'associations' do
    it { should belong_to(:item) }
    it { should have_many(:lanche_porcaos).dependent(:destroy) }
    it { should have_many(:lanches).through(:lanche_porcaos) }
  end

  describe 'callbacks' do
    let(:item) { create(:item, preco: 20.0) }

    describe 'before_save' do
      it 'calculates cost automatically' do
        porcao = build(:porcao, item: item, peso_utilizado: 0.5)
        porcao.save!

        expect(porcao.custo).to be_within(0.01).of(10.0) # 20.0 * 0.5
      end

      it 'recalculates cost when peso_utilizado changes' do
        porcao = create(:porcao, item: item, peso_utilizado: 0.5)
        expect(porcao.custo).to be_within(0.01).of(10.0)

        porcao.update!(peso_utilizado: 0.8)
        expect(porcao.custo).to be_within(0.01).of(16.0) # 20.0 * 0.8
      end

      it 'recalculates cost when item price changes' do
        porcao = create(:porcao, item: item, peso_utilizado: 0.5)
        expect(porcao.custo).to be_within(0.01).of(10.0)

        item.update!(preco: 30.0)
        porcao.save!
        expect(porcao.custo).to be_within(0.01).of(15.0) # 30.0 * 0.5
      end
    end

    describe 'after_update' do
      it 'updates associated lanches costs when custo changes' do
        porcao = create(:porcao, item: item, peso_utilizado: 0.5)
        lanch = create(:lanch)
        create(:lanche_porcao, lanch: lanch, porcao: porcao)

        initial_cost = lanch.reload.custo

        # Change item price which will trigger porcao cost update
        item.update!(preco: 40.0)
        porcao.save!

        expect(lanch.reload.custo).not_to eq initial_cost
      end
    end
  end

  describe 'cost calculation' do
    let(:item) { create(:item, preco: 25.0) }

    it 'calculates cost correctly for different weights' do
      porcao_pequena = create(:porcao, item: item, peso_utilizado: 0.1)
      porcao_media = create(:porcao, item: item, peso_utilizado: 0.5)
      porcao_grande = create(:porcao, item: item, peso_utilizado: 1.0)

      expect(porcao_pequena.custo).to be_within(0.01).of(2.5)   # 25.0 * 0.1
      expect(porcao_media.custo).to be_within(0.01).of(12.5)    # 25.0 * 0.5
      expect(porcao_grande.custo).to be_within(0.01).of(25.0)   # 25.0 * 1.0
    end
  end

  describe 'factory' do
    it 'creates a valid porcao' do
      porcao = create(:porcao)
      expect(porcao).to be_valid
    end

    it 'creates a pequena porcao with trait' do
      porcao = build(:porcao, :pequena)
      expect(porcao.peso_utilizado).to be_between(0.05, 0.2)
    end

    it 'creates a media porcao with trait' do
      porcao = build(:porcao, :media)
      expect(porcao.peso_utilizado).to be_between(0.2, 0.5)
    end

    it 'creates a grande porcao with trait' do
      porcao = build(:porcao, :grande)
      expect(porcao.peso_utilizado).to be_between(0.5, 1.0)
    end
  end
end
