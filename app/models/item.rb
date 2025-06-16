class Item < ApplicationRecord
  # Relacionamentos
  has_many :compras, dependent: :restrict_with_error
  has_many :porcaos, dependent: :restrict_with_error

  validates :nome, presence: true, length: { minimum: 2, maximum: 100 }
  validates :preco, presence: true, numericality: { greater_than: 0 }
  validates :peso, presence: true, numericality: { greater_than: 0 }
  validates :categoria, presence: true

  # Scopes úteis
  scope :ativos, -> { where(ativo: true) }
  scope :disponiveis, -> { where(disponivel: true) }
  scope :por_categoria, ->(categoria) { where(categoria: categoria) }

  # Valores padrão
  after_initialize do
    self.ativo = true if self.ativo.nil?
    self.disponivel = true if self.disponivel.nil?
    self.peso = 1.0 if self.peso.nil? || self.peso.zero?
  end

  # Métodos úteis
  def atualizar_custos_das_porcoes!
    porcaos.each do |porcao|
      novo_custo = preco * porcao.peso_utilizado
      porcao.update_column(:custo, novo_custo.round(2))
    end
  end
end
