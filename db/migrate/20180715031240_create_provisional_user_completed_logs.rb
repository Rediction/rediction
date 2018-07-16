class CreateProvisionalUserCompletedLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :provisional_user_completed_logs, comment: "usersテーブルとprovisional_usersテーブルの結び付き関係を格納" do |t|
      t.references :user, null: false, uniqueness: true, comment: "ユーザーID(FK)"
      t.references :provisional_user, null: false, uniqueness: true, comment: "仮ユーザーID(FK)"
      t.datetime :created_at, null: false
    end
  end
end
