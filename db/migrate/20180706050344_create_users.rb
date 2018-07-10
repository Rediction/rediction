class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string   :email,             null: false, uniqueness: true, comment: "メールアドレス"
      t.string   :password_digest,   null: false, comment: "パスワード"
      t.timestamps
    end
  end
end
