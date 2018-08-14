# == Schema Information
#
# Table name: user_resignation_requests # ユーザーの退会申請が格納されるテーブル
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null              # ユーザーID
#  description :string(255)      not null              # 凍結解除理由
#  created_at  :datetime         not null
#

FactoryBot.define do
  factory :user_resignation_request, class: User::Resignation::Request do
    description "description"
    association :user
  end
end
