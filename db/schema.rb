ActiveRecord::Schema.define(version: 2018_07_06_050529) do

  create_table "user_changes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "更新したユーザーのid"
    t.string "email", null: false, comment: "更新したメールアドレス"
    t.string "password_digest", null: false, comment: "更新されたパスワード"
    t.string "event", null: false, comment: "レコード登録時のイベント"
    t.datetime "created_at", comment: "ユーザー情報が更新された日時"
    t.index ["user_id"], name: "index_user_changes_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "email", null: false, comment: "メールアドレス"
    t.string "password_digest", null: false, comment: "パスワード"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
