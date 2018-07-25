class CreateWordChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :word_changes, comment: "投稿が削除された時の履歴" do |t|
      t.references :user, null: false, foreign_key: true, comment: "ユーザーID(FK)"
      t.references :word, null: false, foreign_key: true, comment: "言葉ID(FK)"
      t.string :name, null: false, comment: "名前"
      t.string :phonetic, null: false, comment: "ふりがな"
      t.string :description, null: false, comment: "説明"
      t.string :event, null: false, comment: "イベント"
      t.datetime :created_at, null: false
    end
  end
end
