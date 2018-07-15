class ProvisionalUserCompletedLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :provisional_user_completed_logs do |t|
      t.bigint    :user_id,              null: false,  uniqueness: true,  comment: "ユーザーID"
      t.bigint    :provisional_user_id,  null: false,  uniqueness: true,  comment: "仮ユーザーID"
      t.datetime  :created_at,           null: false
    end
  end
end
