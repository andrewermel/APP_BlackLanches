class LanchePorcao < ApplicationRecord
  belongs_to :lanch
  belongs_to :porcao

  # Validações para evitar duplicatas
  validates :lanch_id, uniqueness: { scope: :porcao_id }
end
