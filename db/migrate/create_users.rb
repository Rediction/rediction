class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string   :email,             null: false, comment: "メールアドレス"
      t.string   :password_digest,   null: false, comment: "パスワード"
      t.timestamps :created_at,                   comment: "アカウント作成時"
      t.timestamps :updated_at,                   comment: "アカウント更新時"
    end
  end
end