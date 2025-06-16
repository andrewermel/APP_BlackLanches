class Lanch < ApplicationRecord
  # Relacionamentos
  has_many :lanche_porcaos, dependent: :destroy
  has_many :porcaos, through: :lanche_porcaos

  # Validações
  validates :nome, presence: true, length: { minimum: 2, maximum: 100 }

  # Callbacks
  before_save :calcular_custo_e_preco_sugerido
  after_update :atualizar_calculos_se_porcaos_mudaram

  def total_custo
    porcaos.sum(:custo)
  end

  def preco_sugerido_calculado
    total_custo * 2
  end

  # Método para adicionar porção ao lanche
  def adicionar_porcao(porcao)
    unless porcaos.include?(porcao)
      porcaos << porcao
      calcular_custo_e_preco_sugerido
      save
    end
  end

  # Método para remover porção do lanche
  def remover_porcao(porcao)
    porcaos.delete(porcao)
    calcular_custo_e_preco_sugerido
    save
  end

  private

  def calcular_custo_e_preco_sugerido
    self.custo = total_custo
    self.preco_sugerido = preco_sugerido_calculado
  end

  def atualizar_calculos_se_porcaos_mudaram
    if saved_change_to_attribute?("updated_at")
      calcular_custo_e_preco_sugerido
    end
  end
end
