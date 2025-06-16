class CreatePorcaos < ActiveRecord::Migration[8.0]
  def change
    create_table :porcaos do |t|
      t.references :item, null: false, foreign_key: true
      t.decimal :peso_utilizado
      t.decimal :custo

      t.timestamps
    end
  end
end
