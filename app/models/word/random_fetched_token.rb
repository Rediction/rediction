# == Schema Information
#
# Table name: word_random_fetched_tokens # ランダムで取得した言葉に紐づくユニークなトークンが格納されるテーブル
#
#  id         :bigint(8)        not null, primary key
#  token      :string(255)      not null              # トークン
#  created_at :datetime         not null
#

class Word::RandomFetchedToken < ApplicationRecord
  validates :token, presence: true, uniqueness: true
  has_many :fetched_records, dependent: :destroy, class_name: "Word::RandomFetchedRecord",
    foreign_key: :token_id, inverse_of: :token

  class << self
    # トークンに該当するレコードを取得または、新規でレコードを生成し返却
    def first_or_create_unique_token(token)
      fetched_token = find_by(token: token)
      return fetched_token if fetched_token.present?

      create(token: generate_token)
    end

    private

    # ユニークなトークンを生成するメソッド
    def generate_token
      loop do
        token = SecureRandom.uuid
        return token unless exists?(token: token)
      end
    end
  end
end
