class CreateProvisionalUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :provisional_users, comment: "仮ユーザー情報" do |t|
      t.string :email, null: false, comment: "メールアドレス"
      t.string :password_digest, null: false, comment: "パスワード"
      t.string :verification_token, null: false, uniqueness: true, comment: "検証用トークン"
      t.datetime :created_at, null: false
    end
  end
end
