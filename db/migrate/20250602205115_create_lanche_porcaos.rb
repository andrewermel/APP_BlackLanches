class CreateLanchePorcaos < ActiveRecord::Migration[8.0]
  def change
    create_table :lanche_porcaos do |t|
      t.references :lanch, null: false, foreign_key: true
      t.references :porcao, null: false, foreign_key: true

      t.timestamps
    end
  end
end
