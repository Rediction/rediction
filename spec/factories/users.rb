# == Schema Information
#
# Table name: users # ユーザー情報
#
#  id              :bigint(8)        not null, primary key
#  email           :string(255)      not null                        # メールアドレス
#  password_digest :string(255)      not null                        # パスワード
#  freezed         :boolean          default("unfreezed"), not null  # 凍結状態
#  resigned        :boolean          default("unresigned"), not null # 退会状態
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example+#{n}@gmail.com" }
    password "password1"
    freezed :unfreezed
    resigned :unresigned

    factory :user_with_profile do
      after :create do |user|
        create :user_profile, user: user
      end
    end
  end
end
