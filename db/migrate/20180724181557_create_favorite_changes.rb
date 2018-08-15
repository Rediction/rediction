class CreateFavoriteChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_changes, comment: "お気に入りが外された時の履歴" do |t|
      t.bigint :user_id, null: false, comment: "ユーザーID"
      t.bigint :word_id, null: false, comment: "言葉ID"
      t.string :event, null: false, comment: "イベント"
      t.datetime :created_at, null: false
    end
  end
end
