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

  # TODO(shuji ota):形式チェックのvalidationを追加する
  validates :email, presence: true

  # TODO(shuji ota):形式チェックのvalidationを追加する
  validates :password, presence: true, length: { minimum: 8 }
  validates :verification_token, presence: true, uniqueness: true

  # 検証用トークンとともに仮会員の情報を保存するメソッド
  def save_with_verification_token
    self.verification_token = ProvisionalUser.generate_token
    save
  end

  # 仮会員のemailがすでに会員登録されているかを判定するメソッド
  def signed_up_email?
    User.exists?(email: email)
  end

  class << self
    # ユニークな検証用トークンを生成するメソッド
    def generate_token
      loop do
        token = SecureRandom.uuid
        return token unless exists?(verification_token: token)
      end
    end
  end
end
