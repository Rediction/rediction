# == Schema Information
#
# Table name: words # 言葉
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null              # ユーザーID(FK)
#  name        :string(255)      not null              # 名前
#  phonetic    :string(255)      not null              # ふりがな
#  description :string(255)      not null              # 説明
#  created_at  :datetime         not null
#

FactoryBot.define do
  factory :word do
    name "string"
    phonetic "すとりんぐ"
    description "string"
    association :user

    factory :word_with_profile do
      after :create do |word|
        create :user_profile, user: word.user
      end
    end
  end
end
