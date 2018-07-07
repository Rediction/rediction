# == Schema Information
#
# Table name: user_changes
#
#  id              :bigint(8)        not null, primary key
#  user_id         :bigint(8)        not null              # 更新したユーザーのid
#  email           :string(255)      not null              # 更新したメールアドレス
#  password_digest :string(255)      not null              # 更新されたパスワード
#  event           :string(255)      not null              # レコード登録時のイベント
#  created_at      :datetime                               # ユーザー情報が更新された日時
#

class UserChange < ApplicationRecord
  has_secure_password
  belongs_to :user, optional: true

  validates :email,           presence: true
  validates :password_digest, presence: true
end
