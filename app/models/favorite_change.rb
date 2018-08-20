# == Schema Information
#
# Table name: favorite_changes # お気に入りが外された時の履歴
#
#  id          :bigint(8)        not null, primary key
#  favorite_id :bigint(8)        not null              # お気に入りID
#  user_id     :bigint(8)        not null              # ユーザーID
#  word_id     :bigint(8)        not null              # 言葉ID
#  event       :string(255)      not null              # イベント
#  created_at  :datetime         not null
#

class FavoriteChange < ApplicationRecord
  include CreatableFromOriginal
  ORIGINAL_FOREIGN_KEY = :favorite_id
end
