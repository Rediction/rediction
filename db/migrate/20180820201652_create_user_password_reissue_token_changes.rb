class CreateUserPasswordReissueTokenChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :user_password_reissue_token_changes, comment: "ユーザー用のパスワード再発行用トークンの履歴" do |t|
      t.bigint :user_password_reissue_token_id, null: false, comment: "再発行用トークンID"
      t.references :user, null: false, comment: "ユーザーID(FK)"
      t.string :email, null: false, comment: "メールアドレス"
      t.string :token, null: false, comment: "トークン"
      t.boolean :consumed, null: false, default: false, comment: "利用済み"
      t.string :event, null: false, comment: "イベント"
      t.datetime :created_at, null: false
    end
  end
end
