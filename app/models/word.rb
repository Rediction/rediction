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

  validates :user_id, presence: true
  validates :name, presence: true
  validates :phonetic, presence: true
  validates :description, presence: true
end
