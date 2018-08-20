# == Schema Information
#
# Table name: word_random_fetched_tokens # ランダムで取得した言葉に紐づくユニークなトークンが格納されるテーブル
#
#  id         :bigint(8)        not null, primary key
#  token      :string(255)      not null              # トークン
#  created_at :datetime         not null
#

FactoryBot.define do
  factory :word_random_fetched_token, class: Word::RandomFetchedToken do
    sequence(:token) { |n| "xxxxxxxxxxx+#{n}" }
  end
end
