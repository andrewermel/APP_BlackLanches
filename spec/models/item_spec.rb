require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:nome) }
    it { should validate_length_of(:nome).is_at_least(2).is_at_most(100) }
    it { should validate_presence_of(:preco) }
    it { should validate_numericality_of(:preco).is_greater_than(0) }
    it { should validate_presence_of(:peso) }
    it { should validate_numericality_of(:peso).is_greater_than(0) }
    it { should validate_presence_of(:categoria) }
  end

  describe 'associations' do
    it { should have_many(:compras).dependent(:restrict_with_error) }
    it { should have_many(:porcaos).dependent(:restrict_with_error) }
  end

  describe 'scopes' do
    let!(:item_ativo) { create(:item, ativo: true) }
    let!(:item_inativo) { create(:item, ativo: false) }
    let!(:item_disponivel) { create(:item, disponivel: true) }
    let!(:item_indisponivel) { create(:item, disponivel: false) }

    describe '.ativos' do
      it 'returns only active items' do
        expect(Item.ativos).to include(item_ativo)
        expect(Item.ativos).not_to include(item_inativo)
      end
    end

    describe '.disponiveis' do
      it 'returns only available items' do
        expect(Item.disponiveis).to include(item_disponivel)
        expect(Item.disponiveis).not_to include(item_indisponivel)
      end
    end

    describe '.por_categoria' do
      let!(:item_proteina) { create(:item, categoria: 'Proteína') }
      let!(:item_vegetal) { create(:item, categoria: 'Vegetais') }

      it 'returns items filtered by category' do
        expect(Item.por_categoria('Proteína')).to include(item_proteina)
        expect(Item.por_categoria('Proteína')).not_to include(item_vegetal)
      end
    end
  end

  describe 'callbacks' do
    describe 'after_initialize' do
      it 'sets default values' do
        item = Item.new
        expect(item.ativo).to be true
        expect(item.disponivel).to be true
        expect(item.peso).to eq 1.0
      end

      it 'does not override existing values' do
        item = Item.new(ativo: false, disponivel: false, peso: 2.0)
        expect(item.ativo).to be false
        expect(item.disponivel).to be false
        expect(item.peso).to eq 2.0
      end
    end
  end

  describe '#atualizar_custos_das_porcoes!' do
    let(:item) { create(:item, preco: 10.0) }
    let!(:porcao1) { create(:porcao, item: item, peso_utilizado: 0.5) }
    let!(:porcao2) { create(:porcao, item: item, peso_utilizado: 0.3) }

    it 'updates all associated portions costs' do
      item.update!(preco: 20.0)
      item.atualizar_custos_das_porcoes!

      expect(porcao1.reload.custo).to eq 10.0 # 20 * 0.5
      expect(porcao2.reload.custo).to eq 6.0  # 20 * 0.3
    end
  end

  describe 'factory' do
    it 'creates a valid item' do
      item = build(:item)
      expect(item).to be_valid
    end

    it 'creates an inactive item with trait' do
      item = build(:item, :inativo)
      expect(item.ativo).to be false
    end

    it 'creates an unavailable item with trait' do
      item = build(:item, :indisponivel)
      expect(item.disponivel).to be false
    end
  end
end
