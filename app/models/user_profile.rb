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

class UserProfile < ApplicationRecord
  include PerformableWithChanges
  # サービスを利用できる最少年齢
  MINIMUM_AGE = 13

  # サービスを利用できる最長年齢
  MAXIMUM_AGE = 150

  belongs_to :user
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :last_name_kana, presence: true, length: { maximum: 30 }, katakana: true
  validates :first_name, presence: true, length: { maximum: 20 }
  validates :first_name_kana, presence: true, length: { maximum: 30 }, katakana: true
  validates :birth_on, presence: true
  validates :job, presence: true, length: { maximum: 20 }
  validate :check_birth_date, on: :create

  # 登録する年齢に制限を設けるメソッド
  def check_birth_date
    if birth_on.to_datetime > MINIMUM_AGE.years.ago.to_datetime
      errors.add(:birth_on, "が不正です。" + MINIMUM_AGE.to_s + "歳未満はご利用になれません。")
    elsif birth_on.to_datetime < MAXIMUM_AGE.years.ago.to_datetime
      errors.add(:birth_on, "が不正です。" + MAXIMUM_AGE.to_s + "歳以上はご利用になれません。")
    end
  end
end
