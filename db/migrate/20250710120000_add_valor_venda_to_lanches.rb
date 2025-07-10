class AddValorVendaToLanches < ActiveRecord::Migration[7.0]
  def change
    add_column :lanches, :valor_venda, :decimal, precision: 10, scale: 2
  end
end
