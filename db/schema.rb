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

ActiveRecord::Schema.define(version: 2018_08_20_192432) do

  create_table "admin_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "管理者ユーザー", force: :cascade do |t|
    t.string "email", null: false, comment: "メールアドレス"
    t.string "uid", comment: "OAuth用のユニークID"
    t.datetime "created_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
  end

  create_table "favorite_changes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "お気に入りが外された時の履歴", force: :cascade do |t|
    t.bigint "favorite_id", null: false, comment: "お気に入りID"
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.bigint "word_id", null: false, comment: "言葉ID"
    t.string "event", null: false, comment: "イベント"
    t.datetime "created_at", null: false
  end

  create_table "favorites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "お気に入り", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID(FK)"
    t.bigint "word_id", null: false, comment: "言葉ID(FK)"
    t.datetime "created_at", null: false
    t.index ["user_id"], name: "index_favorites_on_user_id"
    t.index ["word_id"], name: "index_favorites_on_word_id"
  end

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
    t.boolean "resigned", default: false, null: false, comment: "退会状態"
    t.string "event", null: false, comment: "レコード登録時のイベント"
    t.datetime "created_at", null: false
  end

  create_table "user_follow_relation_changes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "ユーザーのフォロー関係の履歴", force: :cascade do |t|
    t.bigint "user_follow_relation_id", null: false, comment: "フォロー関係ID"
    t.bigint "following_user_id", null: false, comment: "フォローしているユーザーID"
    t.bigint "followed_user_id", null: false, comment: "フォローされているユーザーID"
    t.string "event", null: false, comment: "レコード登録時のイベント"
    t.datetime "created_at", null: false
    t.index ["followed_user_id"], name: "index_user_follow_relation_changes_on_followed_user_id"
    t.index ["following_user_id"], name: "index_user_follow_relation_changes_on_following_user_id"
  end

  create_table "user_follow_relations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "ユーザーのフォロー関係", force: :cascade do |t|
    t.bigint "following_user_id", null: false, comment: "フォローしているユーザーID"
    t.bigint "followed_user_id", null: false, comment: "フォローされているユーザーID"
    t.datetime "created_at", null: false
    t.index ["followed_user_id"], name: "index_user_follow_relations_on_followed_user_id"
    t.index ["following_user_id"], name: "index_user_follow_relations_on_following_user_id"
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

  create_table "user_resignation_request_cancels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "ユーザーの退会申請のキャンセルが格納されるテーブル", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.string "description", null: false, comment: "退会キャンセル理由"
    t.datetime "created_at", null: false
    t.index ["user_id"], name: "index_user_resignation_request_cancels_on_user_id"
  end

  create_table "user_resignation_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "ユーザーの退会申請が格納されるテーブル", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.string "description", null: false, comment: "凍結解除理由"
    t.datetime "created_at", null: false
    t.index ["user_id"], name: "index_user_resignation_requests_on_user_id"
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
    t.boolean "resigned", default: false, null: false, comment: "退会状態"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "word_changes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "投稿が削除された時の履歴", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.bigint "word_id", null: false, comment: "言葉ID"
    t.string "name", null: false, comment: "名前"
    t.string "phonetic", null: false, comment: "ふりがな"
    t.string "description", null: false, comment: "説明"
    t.string "event", null: false, comment: "イベント"
    t.datetime "created_at", null: false
  end

  create_table "word_random_fetched_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "ランダムで取得した言葉のレコードのIDが格納されるテーブル", force: :cascade do |t|
    t.bigint "token_id", null: false, comment: "トークンID(FK)"
    t.bigint "word_id", null: false, comment: "言葉ID(FK)"
    t.datetime "created_at", null: false
    t.index ["token_id"], name: "index_word_random_fetched_records_on_token_id"
    t.index ["word_id"], name: "index_word_random_fetched_records_on_word_id"
  end

  create_table "word_random_fetched_tokens", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "ランダムで取得した言葉に紐づくユニークなトークンが格納されるテーブル", force: :cascade do |t|
    t.string "token", null: false, comment: "トークン"
    t.datetime "created_at", null: false
    t.index ["token"], name: "index_word_random_fetched_tokens_on_token", unique: true
  end

  create_table "words", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", comment: "言葉", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID(FK)"
    t.string "name", null: false, comment: "名前"
    t.string "phonetic", null: false, comment: "ふりがな"
    t.string "description", null: false, comment: "説明"
    t.datetime "created_at", null: false
    t.index ["user_id"], name: "index_words_on_user_id"
  end

  add_foreign_key "favorites", "users"
  add_foreign_key "favorites", "words"
  add_foreign_key "provisional_user_completed_logs", "provisional_users"
  add_foreign_key "provisional_user_completed_logs", "users"
  add_foreign_key "user_auth_logs", "users"
  add_foreign_key "user_follow_relation_changes", "users", column: "followed_user_id"
  add_foreign_key "user_follow_relation_changes", "users", column: "following_user_id"
  add_foreign_key "user_follow_relations", "users", column: "followed_user_id"
  add_foreign_key "user_follow_relations", "users", column: "following_user_id"
  add_foreign_key "user_freezed_reasons", "users"
  add_foreign_key "user_profiles", "users"
  add_foreign_key "user_unfreezed_reasons", "users"
  add_foreign_key "word_random_fetched_records", "word_random_fetched_tokens", column: "token_id"
  add_foreign_key "word_random_fetched_records", "words"
  add_foreign_key "words", "users"
end
