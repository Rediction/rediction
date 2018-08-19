class CreateWordRandomFetchedRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :word_random_fetched_records, comment: "ランダムで取得した言葉のレコードのIDが格納されるテーブル" do |t|
      t.references :token, null: false, foreign_key: { to_table: :word_random_fetched_tokens }, index: true, comment: "トークンID(FK)"
      t.references :word, null: false, foreign_key: true, index: true, comment: "言葉ID(FK)"
      t.datetime :created_at, null: false
    end
  end
end
