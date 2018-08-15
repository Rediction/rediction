class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites, comment: "お気に入り" do |t|
      t.references :user, null: false, foreign_key: true, comment: "ユーザーID(FK)"
      t.references :word, null: false, foreign_key: true, comment: "言葉ID(FK)"
      t.datetime :created_at, null: false
    end
  end
end
