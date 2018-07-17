# == Schema Information
#
# Table name: user_freezed_reasons # ユーザーのアカウント凍結記録
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null              # ユーザーID(FK)
#  description :string(255)      not null              # 凍結理由
#  created_at  :datetime         not null
#

class UserFreezedReason < ApplicationRecord
  belongs_to :user
  validates :description, presence: true
end
