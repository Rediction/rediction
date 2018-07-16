# == Schema Information
#
# Table name: provisional_users # 仮ユーザー情報
#
#  id                 :bigint(8)        not null, primary key
#  email              :string(255)      not null              # メールアドレス
#  password_digest    :string(255)      not null              # パスワード
#  verification_token :string(255)      not null              # 検証用トークン
#  created_at         :datetime         not null
#

class ProvisionalUser < ApplicationRecord
  has_secure_password

  validates :email, presence: true
  validates :password_digest, presence: true, length: { minimum: 8 }
  validates :verification_token, presence: true
end
