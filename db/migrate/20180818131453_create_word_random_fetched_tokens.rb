class CreateWordRandomFetchedTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :word_random_fetched_tokens, comment: "ランダムで取得した言葉に紐づくユニークなトークンが格納されるテーブル" do |t|
      t.string :token, index: { unique: true }, null: false, comment: "トークン"
      t.datetime :created_at, null: false
    end
  end
end
