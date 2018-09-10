class CreateUserRememberMeTokenChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :user_remember_me_token_changes, comment: "ユーザーのRemember Me機能に利用するトークンの履歴" do |t|
      t.bigint :user_remember_me_token_id, null: false, comment: "Remember MeトークンID"
      t.bigint :user_id, null: false, comment: "ユーザーID"
      t.string :token_digest, null: false, comment: "認証用トークン"
      t.string :event, null: false, comment: "イベント"
      t.datetime :created_at, null: false
    end
  end
end
