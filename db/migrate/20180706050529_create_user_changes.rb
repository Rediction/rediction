class CreateUserChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :user_changes, comment: "ユーザー情報更新履歴" do |t|
      t.bigint    :user_id,          null: false, comment: "更新したユーザーのID(FK)"
      t.string    :email,            null: false, comment: "更新したメールアドレス"
      t.string    :password_digest,  null: false, comment: "更新されたパスワード"
      t.boolean   :freezed,          null: false, comment: "凍結状態"
      t.string    :event,            null: false, comment: "レコード登録時のイベント"
      t.datetime  :created_at,       null: false
    end
  end
end
