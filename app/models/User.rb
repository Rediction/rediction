# == Schema Information
#
# Table name: users # ユーザー情報
#
#  id              :bigint(8)        not null, primary key
#  email           :string(255)      not null                 # メールアドレス
#  password_digest :string(255)      not null                 # パスワード
#  freezed         :boolean          default(FALSE), not null # 凍結状態
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  has_secure_password
  has_one :user_profile, dependent: :destroy
  has_one :provisional_user_completed_log, dependent: :destroy
  has_many :user_freezed_reasons, dependent: :destroy
  has_many :user_unfreezed_reasons, dependent: :destroy
  has_many :user_auth_logs, dependent: :destroy

  validates :email, presence: true
  validates :password_digest, presence: true

end
