class CreateFavoriteChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_changes, comment: "お気に入りが外された時の履歴" do |t|
      t.references :user, null: false, foreign_key: true, comment: "ユーザーID(FK)"
      t.references :word, null: false, foreign_key: true, comment: "言葉ID(FK)"
      t.string :event, null: false, comment: "イベント"
      t.datetime :created_at, null: false
    end
  end
end
