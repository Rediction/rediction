# == Schema Information
#
# Table name: user_profile_changes # ユーザープロフィール更新履歴
#
#  id              :bigint(8)        not null, primary key
#  user_profile_id :bigint(8)        not null              # ユーザープロフィールID
#  user_id         :bigint(8)        not null              # ユーザーID
#  last_name       :string(255)      not null              # 苗字
#  last_name_kana  :string(255)      not null              # 苗字(フリガナ)
#  first_name      :string(255)      not null              # 名前
#  first_name_kana :string(255)      not null              # 名前(フリガナ)
#  birth_on        :date             not null              # 生年月日
#  job             :string(255)      not null              # 職業
#  event           :string(255)      not null              # イベント
#  created_at      :datetime         not null
#

class UserProfileChange < ApplicationRecord
  include CreatableFromOriginal
  ORIGINAL_FOREIGN_KEY = :user_profile_id

  belongs_to :user_profile
end
