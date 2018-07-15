class CreateUserAuthLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :user_auth_logs, comment: "ユーザーアカウント認証記録" do |t|
      t.references    :user,        null: false, comment: "ユーザーID(FK)"
      t.boolean       :success,     null: false, comment: "成功"
      t.datetime      :created_at,  null: false
    end
  end
end
