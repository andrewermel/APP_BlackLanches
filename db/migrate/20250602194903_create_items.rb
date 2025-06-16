class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :nome
      t.decimal :preco
      t.decimal :peso
      t.text :descricao
      t.string :categoria
      t.boolean :disponivel
      t.boolean :ativo

      t.timestamps
    end
  end
end
