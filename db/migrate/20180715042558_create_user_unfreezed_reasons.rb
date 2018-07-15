class CreateUserUnfreezedReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :user_unfreezed_reasons, comment: "ユーザーのアカウント凍結解除記録" do |t|
      t.references   :user,        null: false, foreign_key: true, comment: "ユーザーID(FK)"
      t.string       :description, null: false, comment: "凍結解除理由"
      t.datetime     :created_at,  null: false
    end
  end
end
