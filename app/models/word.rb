# == Schema Information
#
# Table name: words # 言葉
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null              # ユーザーID(FK)
#  name        :string(255)      not null              # 名前
#  phonetic    :string(255)      not null              # ふりがな
#  description :string(255)      not null              # 説明
#  created_at  :datetime         not null
#

class Word < ApplicationRecord
  include PerformableWithChanges

  belongs_to :user
  has_many :random_fetched_records, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :user_id, presence: true
  validates :name, presence: true
  validates :phonetic, presence: true
  validates :description, presence: true

  class << self
    # word_random_fetched_recordsのトークンを元に、取得済みのwordsを除隊してランダムで規定数取得
    # ランダム取得ということもあり、負荷が高いメソッドなので、事前にスコアを振るレコメンドなどに切り替える予定。
    def find_random_by_fetched_token(token:, limit: 10)
      fetched_token = Word::RandomFetchedToken.find_by(token: token)

      includes(user: :profile)
        .where.not(id: fetched_token&.fetched_records&.map(&:word_id))
        .order(Arel.sql("RAND()"))
        .limit(limit)
    end

    def includes_favorite_by_user_id(user_id)
      includes(:favorites).where(favorites: {user_id: [nil, user_id]})
    end

    # 最新のレコードを取得
    # 第二引数(max_fetched_id)で取得する最大のIDを指定可能。
    def find_latest_records(limit: 10, max_fetched_id: nil)
      words = includes(user: :profile).order(id: :desc).limit(limit)

      # 最後に取得したIDがparamsに含まれている場合、それより前のIDを取得するように条件を追加
      words = words.where("words.id < ?", max_fetched_id) if max_fetched_id.present?

      words
    end

    # お気に入り登録されている言葉のみに絞り込む
    def find_favorites_records(limit: 10, max_fetched_id: nil, user_id:)
      words = joins(:favorites).where(favorites: {user_id: user_id})
                               .includes(user: :profile)
                               .order("favorites.id DESC")
                               .limit(limit)

      words = words.where("favorites.id < ?", max_fetched_id) if max_fetched_id.present?

      words
    end
  end
end
