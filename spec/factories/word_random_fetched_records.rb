# == Schema Information
#
# Table name: word_random_fetched_records # ランダムで取得した言葉のレコードのIDが格納されるテーブル
#
#  id         :bigint(8)        not null, primary key
#  token_id   :bigint(8)        not null              # トークンID(FK)
#  word_id    :bigint(8)        not null              # 言葉ID(FK)
#  created_at :datetime         not null
#

FactoryBot.define do
  factory :word_random_fetched_record, class: Word::RandomFetchedRecord do
    association(:token, factory: :word_random_fetched_token)
    association(:word)
  end
end
