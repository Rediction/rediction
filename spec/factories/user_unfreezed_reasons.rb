# == Schema Information
#
# Table name: user_unfreezed_reasons # ユーザーのアカウント凍結解除記録
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null              # ユーザーID(FK)
#  description :string(255)      not null              # 凍結解除理由
#  created_at  :datetime         not null
#

FactoryBot.define do
  factory :user_unfreezed_reason, class: User::UnfreezedReason do
    description "description"
    association :user
  end
end
