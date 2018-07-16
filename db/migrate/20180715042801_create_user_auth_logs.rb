class CreateUserAuthLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :user_auth_logs, comment: "ユーザーのアカウント認証記録が格納されるテーブル" do |t|
      t.references    :user,        null: false, comment: "ユーザーID(FK)"
      t.boolean       :success,     null: false, comment: "ユーザー認証が成功したか失敗を判断したテーブル"
      t.datetime      :created_at,  null: false
    end
  end
end
