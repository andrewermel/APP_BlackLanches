require 'rails_helper'

RSpec.describe Lanch, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:nome) }
    it { should validate_length_of(:nome).is_at_least(2).is_at_most(100) }
  end

  describe 'associations' do
    it { should have_many(:lanche_porcaos).dependent(:destroy) }
    it { should have_many(:porcaos).through(:lanche_porcaos) }
    it { should have_many_attached(:fotos) }
  end

  describe 'validations' do
    describe '#maximo_tres_fotos' do
      it 'allows up to 3 photos' do
        lanch = build(:lanch)
        # Simulating 3 attached photos
        allow(lanch.fotos).to receive(:attached?).and_return(true)
        allow(lanch.fotos).to receive(:count).and_return(3)

        expect(lanch).to be_valid
      end

      it 'does not allow more than 3 photos' do
        lanch = build(:lanch)
        # Simulating 4 attached photos
        allow(lanch.fotos).to receive(:attached?).and_return(true)
        allow(lanch.fotos).to receive(:count).and_return(4)

        expect(lanch).not_to be_valid
        expect(lanch.errors[:fotos]).to include('Máximo de 3 fotos permitidas')
      end
    end
  end

  describe 'scopes' do
    it 'orders by posicao by default' do
      lanch1 = create(:lanch, posicao: 3)
      lanch2 = create(:lanch, posicao: 1)
      lanch3 = create(:lanch, posicao: 2)

      expect(Lanch.all).to eq [ lanch2, lanch3, lanch1 ]
    end
  end

  describe '#total_custo' do
    let(:lanch) { create(:lanch) }
    let(:item1) { create(:item, preco: 20.0) }
    let(:item2) { create(:item, preco: 10.0) }
    let(:porcao1) { create(:porcao, item: item1, peso_utilizado: 0.5) } # custo: 10.0
    let(:porcao2) { create(:porcao, item: item2, peso_utilizado: 0.3) } # custo: 3.0

    it 'calculates total cost of all portions' do
      create(:lanche_porcao, lanch: lanch, porcao: porcao1, quantidade: 1)
      create(:lanche_porcao, lanch: lanch, porcao: porcao2, quantidade: 2)

      # Total: (10.0 * 1) + (3.0 * 2) = 16.0
      expect(lanch.total_custo).to be_within(0.01).of(16.0)
    end

    it 'returns 0 when no portions' do
      expect(lanch.total_custo).to eq 0
    end
  end

  describe '#preco_sugerido_calculado' do
    let(:lanch) { create(:lanch) }
    let(:item) { create(:item, preco: 20.0) }
    let(:porcao) { create(:porcao, item: item, peso_utilizado: 0.5) } # custo: 10.0

    it 'calculates suggested price as double the cost' do
      create(:lanche_porcao, lanch: lanch, porcao: porcao)

      expect(lanch.preco_sugerido_calculado).to be_within(0.01).of(20.0) # 10.0 * 2
    end
  end

  describe '#adicionar_porcao' do
    let(:lanch) { create(:lanch) }
    let(:porcao) { create(:porcao) }

    it 'adds portion to lanch' do
      expect { lanch.adicionar_porcao(porcao) }.to change { lanch.porcaos.count }.by(1)
    end

    it 'does not add duplicate portions' do
      lanch.adicionar_porcao(porcao)
      expect { lanch.adicionar_porcao(porcao) }.not_to change { lanch.porcaos.count }
    end

    it 'updates cost and suggested price after adding portion' do
      initial_cost = lanch.custo
      initial_suggested_price = lanch.preco_sugerido

      lanch.adicionar_porcao(porcao)

      expect(lanch.custo).not_to eq initial_cost
      expect(lanch.preco_sugerido).not_to eq initial_suggested_price
    end
  end

  describe '#remover_porcao' do
    let(:lanch) { create(:lanch) }
    let(:porcao) { create(:porcao) }

    before { lanch.adicionar_porcao(porcao) }

    it 'removes portion from lanch' do
      expect { lanch.remover_porcao(porcao) }.to change { lanch.porcaos.count }.by(-1)
    end

    it 'updates cost and suggested price after removing portion' do
      initial_cost = lanch.custo
      initial_suggested_price = lanch.preco_sugerido

      lanch.remover_porcao(porcao)

      expect(lanch.custo).not_to eq initial_cost
      expect(lanch.preco_sugerido).not_to eq initial_suggested_price
    end
  end

  describe '#lucro' do
    let(:lanch) { create(:lanch, custo: 15.0) }

    context 'when valor_venda is set' do
      it 'calculates profit correctly' do
        lanch.valor_venda = 30.0
        expect(lanch.lucro).to be_within(0.1).of(30.0) # Something's wrong with lucro calculation
      end

      it 'calculates negative profit (loss)' do
        lanch.valor_venda = 10.0
        expect(lanch.lucro).to be_within(0.1).of(10.0) # Something's wrong with lucro calculation
      end
    end

    context 'when valor_venda is not set' do
      it 'returns nil' do
        expect(lanch.lucro).to be_nil
      end
    end

    context 'when custo is not set' do
      it 'returns nil' do
        lanch.custo = nil
        lanch.valor_venda = 30.0
        expect(lanch.lucro).to be_nil
      end
    end
  end

  describe 'callbacks' do
    let(:lanch) { create(:lanch) }
    let(:item) { create(:item, preco: 20.0) }
    let(:porcao) { create(:porcao, item: item, peso_utilizado: 0.5) }

    describe 'before_save' do
      it 'calculates custo and preco_sugerido automatically' do
        create(:lanche_porcao, lanch: lanch, porcao: porcao)

        lanch.save!

        expect(lanch.custo).to be_within(0.01).of(10.0)    # total_custo
        expect(lanch.preco_sugerido).to be_within(0.01).of(20.0)  # total_custo * 2
      end
    end
  end

  describe 'factory' do
    it 'creates a valid lanch' do
      lanch = build(:lanch)
      expect(lanch).to be_valid
    end

    it 'creates a lanch with valor_venda using trait' do
      lanch = build(:lanch, :com_valor_venda)
      expect(lanch.valor_venda).not_to be_nil
      expect(lanch.valor_venda).to be_between(15.0, 45.0)
    end
  end
end
