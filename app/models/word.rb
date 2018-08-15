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
  belongs_to :user

  validates :user_id, presence: true
  validates :name, presence: true
  validates :phonetic, presence: true
  validates :description, presence: true

  def save_with_changes!
    ActiveRecord::Base.transaction do
      save!
      WordChange.create_from_original!(original_record: self, event: "create")
    end
  end

  def destroy_with_changes!
    ActiveRecord::Base.transaction do
      WordChange.create_from_original!(original_record: self, event: "delete")
      destroy!
    end
  end
end
