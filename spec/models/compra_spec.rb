require 'rails_helper'

RSpec.describe Compra, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:nome) }
    it { should validate_presence_of(:preco) }
    it { should validate_numericality_of(:preco).is_greater_than(0) }
    it { should validate_presence_of(:peso) }
    it { should validate_numericality_of(:peso).is_greater_than(0) }
    it { should validate_presence_of(:data_compra) }
  end

  describe 'associations' do
    it { should belong_to(:item) }
  end

  describe 'custom validations' do
    let(:item_inativo) { create(:item, :inativo) }
    let(:item_indisponivel) { create(:item, :indisponivel) }
    let(:item_ativo) { create(:item) }

    describe '#item_deve_estar_disponivel' do
      it 'is invalid when item is not active' do
        compra = build(:compra, item: item_inativo)
        expect(compra).not_to be_valid
        expect(compra.errors[:item]).to include('deve estar ativo')
      end

      it 'is invalid when item is not available' do
        compra = build(:compra, item: item_indisponivel)
        expect(compra).not_to be_valid
        expect(compra.errors[:item]).to include('deve estar disponível')
      end

      it 'is valid when item is active and available' do
        compra = build(:compra, item: item_ativo)
        expect(compra).to be_valid
      end
    end
  end

  describe 'callbacks' do
    let(:item) { create(:item, nome: 'Carne', preco: 20.0, peso: 1.0) }

    describe 'before_validation' do
      it 'copies item data when item_id changes and fields are empty' do
        compra = build(:compra, item: item, nome: '', preco: nil, peso: nil)
        compra.valid?

        expect(compra.nome).to eq 'Carne'
        expect(compra.preco).to eq 20.0
        expect(compra.peso).to eq 1.0
      end

      it 'does not override existing data' do
        compra = build(:compra, item: item, nome: 'Frango', preco: 15.0, peso: 2.0)
        compra.valid?

        expect(compra.nome).to eq 'Frango'
        expect(compra.preco).to eq 15.0
        expect(compra.peso).to eq 2.0
      end
    end

    describe 'after_save' do
      it 'updates item average price' do
        initial_price = item.preco

        create(:compra, item: item, preco: 30.0)

        expect(item.reload.preco).not_to eq initial_price
        expect(item.preco).to be_within(0.1).of(30.0) # only one compra with price 30.0
      end

      it 'updates portions costs after item price changes' do
        porcao = create(:porcao, item: item, peso_utilizado: 0.5)
        initial_cost = porcao.custo

        create(:compra, item: item, preco: 30.0)

        expect(porcao.reload.custo).not_to eq initial_cost
        expect(porcao.custo).to be_within(0.1).of(15.0) # 30.0 * 0.5
      end
    end

    describe 'after_destroy' do
      it 'recalculates item average price when compra is destroyed' do
        create(:compra, item: item, preco: 30.0)
        compra2 = create(:compra, item: item, preco: 40.0)

        expect(item.reload.preco).to be_within(0.1).of(35.0) # average of 30, 40

        compra2.destroy

        expect(item.reload.preco).to be_within(0.1).of(30.0) # only one compra with price 30.0
      end

      it 'sets item price to 0 when no compras remain' do
        compra = create(:compra, item: item, preco: 30.0)

        # Remove the initial item price by updating it
        item.update_column(:preco, 0)

        compra.destroy

        expect(item.reload.preco).to eq 0
      end
    end
  end

  describe 'factory' do
    it 'creates a valid compra' do
      compra = build(:compra)
      expect(compra).to be_valid
    end

    it 'creates a cara compra with trait' do
      compra = build(:compra, :cara)
      expect(compra.preco).to be >= 80.0
    end

    it 'creates a barata compra with trait' do
      compra = build(:compra, :barata)
      expect(compra.preco).to be <= 10.0
    end
  end
end
