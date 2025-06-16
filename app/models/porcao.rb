class Porcao < ApplicationRecord
  belongs_to :item

  # Relacionamentos many-to-many com lanches
  has_many :lanche_porcaos, dependent: :destroy
  has_many :lanches, through: :lanche_porcaos

  # Validações
  validates :peso_utilizado, presence: true, numericality: { greater_than: 0 }
  validates :item_id, presence: true

  # Callbacks
  before_save :calcular_custo
  after_update :atualizar_custos_dos_lanches

  private

  def calcular_custo
    if item && peso_utilizado && item.preco
      # Custo = (preço do item por kg) * (peso utilizado)
      self.custo = item.preco * peso_utilizado
    end
  end

  def atualizar_custos_dos_lanches
    # Atualiza o custo de todos os lanches que usam esta porção
    if saved_change_to_custo?
      lanches.each(&:save)
    end
  end
end
