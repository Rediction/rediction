class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words, comment: "言葉" do |t|
      t.references :user, null: false, foreign_key: true, comment: "ユーザーID(FK)"
      t.string :name, null: false, comment: "名前"
      t.string :phonetic, null: false, comment: "ふりがな"
      t.string :description, null: false, comment: "説明"
      t.datetime :created_at, null: false
    end
  end
end
