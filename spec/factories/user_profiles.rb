# == Schema Information
#
# Table name: user_profiles # ユーザープロフィール情報
#
#  id              :bigint(8)        not null, primary key
#  user_id         :bigint(8)        not null              # ユーザーID(FK)
#  last_name       :string(255)      not null              # 苗字
#  last_name_kana  :string(255)      not null              # 苗字(フリガナ)
#  first_name      :string(255)      not null              # 名前
#  first_name_kana :string(255)      not null              # 名前(フリガナ)
#  birth_on        :date             not null              # 生年月日
#  job             :string(255)      not null              # 職業
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :user_profile do
    last_name "string"
    last_name_kana "string"
    first_name "string"
    first_name_kana "string"
    birth_on 15.years.ago
    job "string"
    association :user
  end
end
