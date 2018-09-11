# == Schema Information
#
# Table name: provisional_users # 仮ユーザー情報
#
#  id                 :bigint(8)        not null, primary key
#  email              :string(255)      not null              # メールアドレス
#  password_digest    :string(255)      not null              # パスワード
#  verification_token :string(255)      not null              # 検証用トークン
#  created_at         :datetime         not null
#

FactoryBot.define do
  factory :provisional_user do
    sequence(:email) { |n| "example+#{n}@gmail.com" }
    password "Password1!"
    sequence(:verification_token) { |n| "xxxxxxxxxxxxx#{n}" }
  end
end
