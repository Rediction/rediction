# == Schema Information
#
# Table name: user_unfreezed_reasons # ユーザーのアカウント凍結解除記録
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null              # ユーザーID(FK)
#  description :string(255)      not null              # 凍結解除理由
#  created_at  :datetime         not null
#

class User::UnfreezedReason < ApplicationRecord
  belongs_to :user
  validates :description, presence: true, length: {maximum: 1000}

  # レコードを保存して、リレーションのあるユーザーを凍結させるメソッド
  def save_and_lift_user_freeze!
    ActiveRecord::Base.transaction do
      save
      user.update_with_changes!(freezed: :unfreezed)
    end
  end
end
