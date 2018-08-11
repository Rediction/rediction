# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_07_15_042801) do

  create_table "provisional_user_completed_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "usersテーブルとprovisional_usersテーブルの結び付き関係を格納", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID(FK)"
    t.bigint "provisional_user_id", null: false, comment: "仮ユーザーID(FK)"
    t.datetime "created_at", null: false
    t.index ["provisional_user_id"], name: "index_provisional_user_completed_logs_on_provisional_user_id", unique: true
    t.index ["user_id"], name: "index_provisional_user_completed_logs_on_user_id", unique: true
  end

  create_table "provisional_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "仮ユーザー情報", force: :cascade do |t|
    t.string "email", null: false, comment: "メールアドレス"
    t.string "password_digest", null: false, comment: "パスワード"
    t.string "verification_token", null: false, comment: "検証用トークン"
    t.datetime "created_at", null: false
    t.index ["verification_token"], name: "index_provisional_users_on_verification_token", unique: true
  end

  create_table "user_auth_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "ユーザーのアカウント認証記録が格納されるテーブル", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID(FK)"
    t.boolean "success", null: false, comment: "ユーザー認証が成功したか失敗したかを判断した結果が反映されるテーブル"
    t.datetime "created_at", null: false
    t.index ["user_id"], name: "index_user_auth_logs_on_user_id"
  end

  create_table "user_changes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "ユーザー情報更新履歴", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "更新したユーザーのID"
    t.string "email", null: false, comment: "更新したメールアドレス"
    t.string "password_digest", null: false, comment: "更新されたパスワード"
    t.boolean "freezed", null: false, comment: "凍結状態"
    t.string "event", null: false, comment: "レコード登録時のイベント"
    t.datetime "created_at", null: false
  end

  create_table "user_freezed_reasons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "ユーザーのアカウント凍結記録", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID(FK)"
    t.string "description", null: false, comment: "凍結理由"
    t.datetime "created_at", null: false
    t.index ["user_id"], name: "index_user_freezed_reasons_on_user_id"
  end

  create_table "user_profile_changes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "ユーザープロフィール更新履歴", force: :cascade do |t|
    t.bigint "user_profile_id", null: false, comment: "ユーザープロフィールID"
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.string "last_name", null: false, comment: "苗字"
    t.string "last_name_kana", null: false, comment: "苗字(フリガナ)"
    t.string "first_name", null: false, comment: "名前"
    t.string "first_name_kana", null: false, comment: "名前(フリガナ)"
    t.date "birth_on", null: false, comment: "生年月日"
    t.string "job", null: false, comment: "職業"
    t.string "event", null: false, comment: "イベント"
    t.datetime "created_at", null: false
  end

  create_table "user_profiles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "ユーザープロフィール情報", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID(FK)"
    t.string "last_name", null: false, comment: "苗字"
    t.string "last_name_kana", null: false, comment: "苗字(フリガナ)"
    t.string "first_name", null: false, comment: "名前"
    t.string "first_name_kana", null: false, comment: "名前(フリガナ)"
    t.date "birth_on", null: false, comment: "生年月日"
    t.string "job", null: false, comment: "職業"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_profiles_on_user_id", unique: true
  end

  create_table "user_unfreezed_reasons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "ユーザーのアカウント凍結解除記録", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID(FK)"
    t.string "description", null: false, comment: "凍結解除理由"
    t.datetime "created_at", null: false
    t.index ["user_id"], name: "index_user_unfreezed_reasons_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "ユーザー情報", force: :cascade do |t|
    t.string "email", null: false, comment: "メールアドレス"
    t.string "password_digest", null: false, comment: "パスワード"
    t.boolean "freezed", default: false, null: false, comment: "凍結状態"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "provisional_user_completed_logs", "provisional_users"
  add_foreign_key "provisional_user_completed_logs", "users"
  add_foreign_key "user_auth_logs", "users"
  add_foreign_key "user_freezed_reasons", "users"
  add_foreign_key "user_profiles", "users"
  add_foreign_key "user_unfreezed_reasons", "users"
end
