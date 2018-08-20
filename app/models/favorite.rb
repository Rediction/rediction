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

  class << self
    # 言葉のお気に入り登録を切り替える処理
    # お気に入り登録中の場合は解除し、未登録の場合は新しく登録
    def toggle_status!(word_id:, user_id:)
      favorite = where(user_id: user_id, word_id: word_id)

      if favorite.present?
        # お気に入りを解除し、nilを返却
        favorite.destroy_with_changes!
        nil
      else
        # お気に入りを登録し、登録したレコードのインスタンスを返却
        create_with_changes!(user_id: user_id, word_id: word_id)
      end
    end
  end
end
