class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, comment: "ユーザー情報" do |t|
      t.string :email, null: false, index: { unique: true }, comment: "メールアドレス"
      t.string :password_digest, null: false, comment: "パスワード"
      t.boolean :freezed, null: false, default: false, comment: "凍結状態"
      t.boolean :resigned, null: false, default: false, comment: "退会状態"
      t.timestamps
    end
  end
end
