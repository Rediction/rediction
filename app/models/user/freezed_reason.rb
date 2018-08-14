# == Schema Information
#
# Table name: user_freezed_reasons # ユーザーのアカウント凍結記録
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null              # ユーザーID(FK)
#  description :string(255)      not null              # 凍結理由
#  created_at  :datetime         not null
#

class User::FreezedReason < ApplicationRecord
  belongs_to :user
  validates :description, presence: true, length: {maximum: 140}

  # レコードを保存して、リレーションのあるユーザーを凍結させるメソッド
  def save_and_freeze_user!
    ActiveRecord::Base.transaction do
      save!
      user.update_with_changes!(freezed: :freezed)
      self
    end
  end
end
