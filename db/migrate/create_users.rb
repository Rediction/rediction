class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string   :email,             null: false, comment: "ユーザーのメールアドレス"
      t.string   :password_digest,   null: false, comment: "ユーザーのパスワード"
      t.timestamps :created_at,      null: false, comment: "ユーザーのアカウントが作成された日時"
      t.timestamps :updated_at,      null: false, comment: "ユーザーのアカウントが変更された日時"
    end
  end
end