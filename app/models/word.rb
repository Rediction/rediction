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
  before_destroy :remove_word

  def remove_word
    WordChange.create(user_id: user_id, word_id: id, name: name, phonetic: phonetic, description: description, event: "deleted")
  end
end
