# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  email           :string(255)      not null              # メールアドレス
#  password_digest :string(255)      not null              # パスワード
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  has_secure_password

  validates :email,           presence: true
  validates :password_digest, presence: true
end
