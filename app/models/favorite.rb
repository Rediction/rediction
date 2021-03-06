# == Schema Information
#
# Table name: favorites # お気に入り
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null              # ユーザーID(FK)
#  word_id    :bigint(8)        not null              # 言葉ID(FK)
#  created_at :datetime         not null
#

class Favorite < ApplicationRecord
  include PerformableWithChanges

  belongs_to :user
  belongs_to :word

  class << self
    # 言葉のお気に入り登録を切り替える処理
    # お気に入り登録中の場合は解除し、未登録の場合は新しく登録
    def toggle_status!(word_id:, user_id:)
      favorite = find_by(user_id: user_id, word_id: word_id)

      if favorite.present?
        # お気に入りを解除し、nilを返却
        favorite.destroy_with_changes!
        nil
      else
        # お気に入りを登録し、登録したレコードのインスタンスを返却
        create_with_changes!(user_id: user_id, word_id: word_id)
      end
    end

    # wordsのうちuser_idがお気に入り登録中のwordのみを抽出して、そのIDを配列で返却
    def extract_favorite_word_ids(words:, user_id:)
      where(word_id: words.map(&:id), user_id: user_id).map(&:word_id)
    end

    # words(複数)のお気に入り件数をハッシュ形式で返却
    # ハッシュの形式 : { word_id => お気に入り数 }
    def favorite_counts_hash(words)
      select("word_id").select("count(word_id) as favorite_count")
                       .where(word_id: words.map(&:id))
                       .group(:word_id)
                       .reduce(Hash.new) { |sum, v| sum.merge(v.word_id => v.favorite_count) }
    end
  end
end
