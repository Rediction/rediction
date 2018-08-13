# == Schema Information
#
# Table name: admin_users # 管理者ユーザー
#
#  id         :bigint(8)        not null, primary key
#  email      :string(255)      not null              # メールアドレス
#  uid        :string(255)                            # OAuth用のユニークID
#  created_at :datetime         not null
#

FactoryBot.define do
  factory :admin_user, class: Admin::User do
    sequence(:email) { |n| "example+#{n}@gmail.com" }
    uid "xxxxxxxxxxxxxxxxxxxxx"
  end
end
