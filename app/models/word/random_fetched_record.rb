# == Schema Information
#
# Table name: word_random_fetched_records # ランダムで取得した言葉のレコードのIDが格納されるテーブル
#
#  id         :bigint(8)        not null, primary key
#  token_id   :bigint(8)        not null              # トークンID(FK)
#  word_id    :bigint(8)        not null              # 言葉ID(FK)
#  created_at :datetime         not null
#

class Word::RandomFetchedRecord < ApplicationRecord
  belongs_to :token, class_name: "Word::RandomFetchedToken"
  belongs_to :word

  class << self
    def bulk_insert_by_words_and_token_id(token_id:, words:)
      fetched_records = []
      words.each do |word|
        fetched_records << new(token_id: token_id, word_id: word.id)
      end

      # バルクインサート
      import(fetched_records)
    end
  end
end
