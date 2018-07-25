# == Schema Information
#
# Table name: favorite_changes # お気に入りが外された時の履歴
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null              # ユーザーID(FK)
#  word_id    :bigint(8)        not null              # 言葉ID(FK)
#  event      :string(255)      not null              # イベント
#  created_at :datetime         not null
#

class FavoriteChange < ApplicationRecord
end
