class CreateWordChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :word_changes, comment: "投稿が削除された時の履歴" do |t|
      t.bigint :user_id, null: false, comment: "ユーザーID"
      t.bigint :word_id, null: false, comment: "言葉ID"
      t.string :name, null: false, comment: "名前"
      t.string :phonetic, null: false, comment: "ふりがな"
      t.string :description, null: false, comment: "説明"
      t.string :event, null: false, comment: "イベント"
      t.datetime :created_at, null: false
    end
  end
end
