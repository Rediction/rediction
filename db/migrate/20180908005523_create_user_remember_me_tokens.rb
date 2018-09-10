class CreateUserRememberMeTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :user_remember_me_tokens, comment: "ユーザーのRemember Me機能に利用するトークン" do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }, comment: "ユーザーID(FK)"
      t.string :token_digest, null: false, comment: "認証用トークン"
      t.timestamps
    end
  end
end
