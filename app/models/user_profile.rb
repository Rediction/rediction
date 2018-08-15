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
  belongs_to :user
  validates :last_name, presence: true, length: { maximum: 20 }

  # TODO(shuji ota):字数制限と正規表現のValidatorクラスを使ってそれを利用するようにする
  validates :last_name_kana, presence: true, length: { maximum: 30 },
             format: { with: /\A[ァ-ヴー]+\z/, message: "にはカタカナのみが使用できます。"}

  validates :first_name, presence: true, length: { maximum: 20 }

  # TODO(shuji ota):字数制限と正規表現のValidatorクラスを使ってそれを利用するようにする
  validates :first_name_kana, presence: true, length: { maximum: 30 },
             format: { with: /\A[ァ-ヴー]+\z/, message: "にはカタカナのみが使用できます。"}

  validates :birth_on, presence: true
  validates :job, presence: true, length: { maximum: 20 }
  validate :check_birth_date

  MINIMUM_AGE = 13
  MAXIMUM_AGE = 150

  # 生年月日から年齢を計算するメソッド
  def check_birth_date
    age = (Time.zone.today.strftime("%Y%m%d").to_i - birth_on.strftime("%Y%m%d").to_i) / 10000
    errors.add(:birth_on, "が不正です。" + MINIMUM_AGE + "歳未満はご利用になれません。") if age < MINIMUM_AGE
  end

  # 会員プロフィールテーブルをchangesテーブルとともに作成するメソッド
  def save_with_changes!
    ActiveRecord::Base.transaction do
      save!
      UserProfileChange.create_from_original!(original_record: self, event: "create")
    end
  end
end
