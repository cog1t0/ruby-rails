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

ActiveRecord::Schema[7.0].define(version: 2024_09_01_091707) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "choice_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["choice_id"], name: "index_answers_on_choice_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "big_five_progresses", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "current_question_id"
    t.integer "next_question_id"
    t.boolean "finished", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_big_five_progresses_on_user_id"
  end

  create_table "choices", force: :cascade do |t|
    t.bigint "question_id"
    t.text "text"
    t.integer "p_code_10", default: 0
    t.integer "p_code_11", default: 0
    t.integer "p_code_20", default: 0
    t.integer "p_code_21", default: 0
    t.integer "p_code_30", default: 0
    t.integer "p_code_31", default: 0
    t.integer "p_code_40", default: 0
    t.integer "p_code_41", default: 0
    t.integer "p_code_50", default: 0
    t.integer "p_code_51", default: 0
    t.text "memo"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_choices_on_question_id"
  end

  create_table "personalities", force: :cascade do |t|
    t.string "code1", null: false
    t.string "code2"
    t.string "usagi"
    t.text "description"
    t.text "keyword"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "deleted_at"
    t.text "memo"
    t.boolean "big_five_flg", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "talk_logs", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "role", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_talk_logs_on_user_id"
  end

  create_table "user_personalities", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "p_code_10", default: 0
    t.integer "p_code_11", default: 0
    t.integer "p_code_20", default: 0
    t.integer "p_code_21", default: 0
    t.integer "p_code_30", default: 0
    t.integer "p_code_31", default: 0
    t.integer "p_code_40", default: 0
    t.integer "p_code_41", default: 0
    t.integer "p_code_50", default: 0
    t.integer "p_code_51", default: 0
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_personalities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "line_id", null: false
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.boolean "subscription_flg", default: false
    t.date "expiration_date"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "answers", "choices"
  add_foreign_key "answers", "users"
  add_foreign_key "big_five_progresses", "users"
  add_foreign_key "choices", "questions"
  add_foreign_key "talk_logs", "users"
  add_foreign_key "user_personalities", "users"
end
