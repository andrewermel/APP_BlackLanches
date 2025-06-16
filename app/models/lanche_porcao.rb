class LanchePorcao < ApplicationRecord
  belongs_to :lanch
  belongs_to :porcao

  # Validações para evitar duplicatas e garantir quantidade válida
  validates :lanch_id, uniqueness: { scope: :porcao_id }
  validates :quantidade, presence: true, numericality: { greater_than: 0, only_integer: true }

  # Valor padrão para quantidade
  after_initialize do
    self.quantidade = 1 if self.quantidade.nil?
  end
end
