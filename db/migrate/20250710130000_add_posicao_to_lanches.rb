class AddPosicaoToLanches < ActiveRecord::Migration[7.0]
  def change
    add_column :lanches, :posicao, :integer
  end
end
