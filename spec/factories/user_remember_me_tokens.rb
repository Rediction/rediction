# == Schema Information
#
# Table name: user_remember_me_tokens # ユーザーのRemember Me機能に利用するトークン
#
#  id           :bigint(8)        not null, primary key
#  user_id      :bigint(8)        not null              # ユーザーID(FK)
#  token_digest :string(255)      not null              # 認証用トークン
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :user_remember_me_token, class: User::RememberMeToken do
    token_digest "xxxxxxxxxxxxxxxxxxxxxxx"
    association :user
  end
end
