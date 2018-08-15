# == Schema Information
#
# Table name: user_resignation_request_cancels # ユーザーの退会申請のキャンセルが格納されるテーブル
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null              # ユーザーID
#  description :string(255)      not null              # 退会キャンセル理由
#  created_at  :datetime         not null
#

FactoryBot.define do
  factory :user_resignation_request_cancel, class: User::Resignation::RequestCancel do
    description "description"
    association :user
  end
end
