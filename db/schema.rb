# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_02_205115) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "compras", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.string "nome"
    t.decimal "preco"
    t.decimal "peso"
    t.date "data_compra"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_compras_on_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "nome"
    t.decimal "preco"
    t.decimal "peso"
    t.text "descricao"
    t.string "categoria"
    t.boolean "disponivel"
    t.boolean "ativo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lanche_porcaos", force: :cascade do |t|
    t.bigint "lanch_id", null: false
    t.bigint "porcao_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lanch_id"], name: "index_lanche_porcaos_on_lanch_id"
    t.index ["porcao_id"], name: "index_lanche_porcaos_on_porcao_id"
  end

  create_table "lanches", force: :cascade do |t|
    t.string "nome"
    t.text "ingredientes"
    t.decimal "custo"
    t.decimal "preco_sugerido"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "porcaos", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.decimal "peso_utilizado"
    t.decimal "custo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_porcaos_on_item_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "compras", "items"
  add_foreign_key "lanche_porcaos", "lanches"
  add_foreign_key "lanche_porcaos", "porcaos"
  add_foreign_key "porcaos", "items"
end
