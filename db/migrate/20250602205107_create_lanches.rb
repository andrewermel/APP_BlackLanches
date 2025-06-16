class CreateLanches < ActiveRecord::Migration[8.0]
  def change
    create_table :lanches do |t|
      t.string :nome
      t.text :ingredientes
      t.decimal :custo
      t.decimal :preco_sugerido

      t.timestamps
    end
  end
end
