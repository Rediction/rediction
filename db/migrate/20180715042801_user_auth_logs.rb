class UserAuthLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :user_auth_logs do |t|
      t.bigint    :user_id,     null: false, comment: "ユーザーID"
      t.boolean   :success,     null: false, comment: "成功"
      t.datetime  :created_at,  null: false
    end
  end
end
