class CreateUserPasswordReissueTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :user_password_reissue_tokens, comment: "ユーザー用のパスワード再発行用トークン" do |t|
      t.references :user, null: false, foreign_key: true, index: true, comment: "ユーザーID(FK)"
      t.string :email, null: false, comment: "メールアドレス"
      t.string :token, null: false, comment: "トークン"
      t.boolean :consumed, null: false, default: false, comment: "利用済み"
      t.timestamps
    end
  end
end
