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
  has_one :provisional_user_completed_log, dependent: :destroy

  validates :email, presence: true
  validates :password, presence: true, length: { minimum: 8 }
  validates :verification_token, presence: true, uniqueness: true

  # 検証用トークンとともに仮会員の情報を保存するもの
  def save_with_verification_token
    self.verification_token = ProvisionalUser.generate_token
    save
  end

  #ユニークなトークンを生成するもの
  class << self
    def generate_token
      loop do
        token = SecureRandom.uuid
        return token unless exists?(verification_token: "token")
      end
    end
  end
end
