# == Schema Information
#
# Table name: user_password_reissue_tokens # ユーザー用のパスワード再発行用トークン
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null              # ユーザーID(FK)
#  email      :string(255)      not null              # メールアドレス
#  token      :string(255)      not null              # トークン
#  consumed   :boolean          not null              # 利用済み
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User::PasswordReissueToken < ApplicationRecord
  include PerformableWithChanges

  # トークンの有効期限(単位は分)
  EXPIRED_MINITUES = 10

  belongs_to :user

  validates :email, presence: true, email: true
  validates :token, presence: true
  validate :check_signed_up_email_status

  enum consumed: {consumed: true, unconsumed: false}

  # メールアドレスの登録状態を確認するValidation
  def check_signed_up_email_status
    unless User.exists?(email: email)
      errors.add(:email, "は未登録のアドレスです。登録されているメールアドレスをご利用ください。")
    end
  end

  # 検証用トークンとともに仮会員の情報を保存するメソッド
  def save_with_token_and_user!
    self.user = User.find_by(email: email)
    self.token = self.class.generate_token
    save_with_changes!
  end

  class << self
    # トークンが利用可能かの判定
    # 条件 : 有効期限内 & 最新のトークン & 未使用
    def available_token?(token)
      record = where("created_at >= ?", EXPIRED_MINITUES.minutes.ago).order(id: :desc).find_by(token: token)
      record&.unconsumed? || false
    end

    # ユニークな検証用トークンを生成するメソッド
    # TODO (Shokei Takanashi) : ユニークなランダムトークン生成処理としてModuleに切り出す。
    def generate_token
      loop do
        token = SecureRandom.uuid
        return token unless exists?(token: token)
      end
    end
  end
end
