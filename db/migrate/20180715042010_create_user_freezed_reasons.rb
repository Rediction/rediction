class CreateUserFreezedReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :user_freezed_reasons, comment: "ユーザーのアカウント凍結記録" do |t|
      t.references   :user,        null: false, foreign_key: true, comment: "ユーザーID(FK)"
      t.string       :description, null: false, comment: "凍結理由"
      t.datetime     :created_at,  null: false
    end
  end
end
