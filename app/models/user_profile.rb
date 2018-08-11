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
  validates :last_name_kana, presence: true, length: { maximum: 30 }, format: { with: /\A[ァ-ヴー]+\z/ }
  validates :first_name, presence: true, length: { maximum: 20 }
  validates :first_name_kana, presence: true, length: { maximum: 30 }, format: { with: /\A[ァ-ヴー]+\z/ }
  validates :birth_on, presence: true
  validates :job, presence: true

  class << self
    # 会員プロフィールテーブルをchangesテーブルとともに作成するメソッド
    def save_with_changes!(user_profile_params:, session_id:)
      ActiveRecord::Base.transaction do
        user_profile = UserProfile.new(user_profile_params)
        user_profile.user_id = session_id
        user_profile.save
        UserProfileChange.create_from_original!(original_record: user_profile, event: "create")
      end
    end
  end
end
