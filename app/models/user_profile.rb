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
  validates :last_name, presence: true, length: { maximum: 20, message: "の長さは最大20文字までです。" }

  # TODO(shuji ota):Validatorクラスを使ってそれを利用するようにする
  validates :last_name_kana, presence: true, length: { maximum: 30, message: "の長さは最大30文字までです。" },
             format: { with: /\A[ァ-ヴー]+\z/, message: "にはカタカナのみが使用できます。"}

  validates :first_name, presence: true, length: { maximum: 20, message: "の長さは最大20文字までです。" }

  # TODO(shuji ota):Validatorクラスを使ってそれを利用するようにする
  validates :first_name_kana, presence: true, length: { maximum: 30, message: "の長さは最大30文字までです。" },
             format: { with: /\A[ァ-ヴー]+\z/, message: "にはカタカナのみが使用できます。"}

  validates :birth_on, presence: true
  validates :job, presence: true, length: { maximum: 20 }
  validate :check_birth_date

    # 生年月日を計算するメソッド
    def check_birth_date
      date_format = "%Y%m%d"
      age = (Time.zone.today.strftime(date_format).to_i - birth_on.strftime(date_format).to_i) / 10000

      return errors.add(:birth_on, "が不正です。6歳未満はご利用になれません。") if age < 6
    end

  class << self
    # 会員プロフィールテーブルをchangesテーブルとともに作成するメソッド
    def save_with_changes!(user_profile_params:, current_user_id:)
      ActiveRecord::Base.transaction do
        user_profile = UserProfile.new(user_profile_params.merge(user_id: current_user_id))
        user_profile.save!
        UserProfileChange.create_from_original!(original_record: user_profile, event: "create")
      end
    end
  end
end
