class CreateCompras < ActiveRecord::Migration[8.0]
  def change
    create_table :compras do |t|
      t.references :item, null: false, foreign_key: true
      t.string :nome
      t.decimal :preco
      t.decimal :peso
      t.date :data_compra

      t.timestamps
    end
  end
end
