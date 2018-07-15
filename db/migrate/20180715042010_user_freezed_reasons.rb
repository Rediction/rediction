class UserFreezedReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :user_freezed_reasons do |t|
      t.bigint   :user_id,     null: false, comment: "ユーザーID"
      t.string   :description, null: false, comment: "凍結理由"
      t.datetime :created_at,  null: false
    end
  end
end
