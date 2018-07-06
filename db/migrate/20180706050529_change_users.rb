class ChangeUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :user_changes, :user_id

    create_table :user_changes do |t|
      t.bigint    :user_id,          null: false, comment: "更新したユーザーのid"
      t.string    :email,            null: false, comment: "更新したメールアドレス"
      t.string    :password_digest,  null: false, comment: "更新されたパスワード"
      t.string    :event,            null: false, comment: "レコード登録時のイベント"
      t.datetime  :created_at,                    comment: "ユーザー情報が更新された日時"
    end
  end
end
