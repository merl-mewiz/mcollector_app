# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_21_101210) do

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "sku"
    t.text "description"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "preview_url"
    t.string "brand_name"
    t.string "brand_url"
    t.string "brand_img_url"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "items_keywords", id: false, force: :cascade do |t|
    t.integer "item_id"
    t.integer "keyword_id"
    t.index ["item_id"], name: "index_items_keywords_on_item_id"
    t.index ["keyword_id"], name: "index_items_keywords_on_keyword_id"
  end

  create_table "keyword_logs", id: false, force: :cascade do |t|
    t.string "log_text"
    t.datetime "log_date"
    t.integer "keyword_id", null: false
    t.index ["keyword_id"], name: "index_keyword_logs_on_keyword_id"
  end

  create_table "keywords", force: :cascade do |t|
    t.string "name", null: false
    t.integer "results_count", default: 0
    t.datetime "last_collect_date"
    t.integer "status", limit: 2, default: 0
    t.datetime "status_error_date"
    t.index ["name"], name: "index_keywords_on_name", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "fio", default: "", null: false
    t.string "phone", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role_id", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  create_table "wb_stat_keywords", id: false, force: :cascade do |t|
    t.string "sku"
    t.string "keyword"
    t.integer "position"
    t.datetime "search_date"
  end

  add_foreign_key "items", "users"
  add_foreign_key "keyword_logs", "keywords"
  add_foreign_key "users", "roles"
end
