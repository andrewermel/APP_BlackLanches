class Compra < ApplicationRecord
  belongs_to :item

  validates :nome, presence: true
  validates :preco, presence: true, numericality: { greater_than: 0 }
  validates :peso, presence: true, numericality: { greater_than: 0 }
  validates :data_compra, presence: true

  # Validação para garantir que só pode comprar items ativos e disponíveis
  validate :item_deve_estar_disponivel

  # Callback para atualizar o item após salvar a compra
  after_save :atualizar_item_com_media
  after_destroy :atualizar_item_com_media

  # Callback para copiar dados do item apenas se os campos estiverem vazios
  before_validation :copiar_dados_do_item_se_vazio, if: :item_id_changed?

  private

  def item_deve_estar_disponivel
    return unless item

    errors.add(:item, "deve estar ativo") unless item.ativo?
    errors.add(:item, "deve estar disponível") unless item.disponivel?
  end

  def copiar_dados_do_item_se_vazio
    return unless item

    self.nome = item.nome if nome.blank?
    self.preco = item.preco if preco.blank? || preco.zero?
    self.peso = item.peso if peso.blank? || peso.zero?
  end

  def atualizar_item_com_media
    return unless item

    compras_do_item = item.compras

    if compras_do_item.any?
      # Calcula apenas a média dos preços
      preco_medio = compras_do_item.average(:preco)

      # Atualiza apenas o preço do item, peso fica fixo em 1kg
      item.update_column(:preco, preco_medio.round(2))

      # Atualiza o custo de todas as porções relacionadas a este item
      atualizar_custos_das_porcoes
    else
      # Se não há compras, zera apenas o preço
      item.update_column(:preco, 0)

      # Atualiza o custo de todas as porções relacionadas a este item
      atualizar_custos_das_porcoes
    end
  end

  def atualizar_custos_das_porcoes
    return unless item

    # Recalcula o custo de todas as porções deste item
    item.porcaos.each do |porcao|
      novo_custo = item.preco * porcao.peso_utilizado
      porcao.update_column(:custo, novo_custo.round(2))
    end
  end
end
