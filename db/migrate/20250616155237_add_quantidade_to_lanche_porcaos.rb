class AddQuantidadeToLanchePorcaos < ActiveRecord::Migration[8.0]
  def change
    add_column :lanche_porcaos, :quantidade, :integer, default: 1, null: false
  end
end
