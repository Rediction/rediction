# == Schema Information
#
# Table name: word_changes # 投稿が削除された時の履歴
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null              # ユーザーID(FK)
#  word_id     :bigint(8)        not null              # 言葉ID(FK)
#  name        :string(255)      not null              # 名前
#  phonetic    :string(255)      not null              # ふりがな
#  description :string(255)      not null              # 説明
#  event       :string(255)      not null              # イベント
#  created_at  :datetime         not null
#

class WordChange < ApplicationRecord
end
