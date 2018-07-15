class ProvisionalUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :provisional_users do |t|
      t.string    :email,               null: false, comment: "メールアドレス"
      t.string    :password_digest,     null: false, comment: "パスワード"
      t.string    :verification_token,  null: false, comment: "検証用トークン"
      t.datetime  :created_at,          null: false
    end
  end
end
