# == Schema Information
#
# Table name: admin_users # 管理者ユーザー
#
#  id         :bigint(8)        not null, primary key
#  email      :string(255)      not null              # メールアドレス
#  uid        :string(255)                            # OAuth用のユニークID
#  created_at :datetime         not null
#

class Admin::User < ApplicationRecord
  self.table_name = "admin_users"

  # TODO(Shokei Takanashi) : 企業ドメイン獲得後は、管理者のメールアドレスを取得企業ドメインに限定するようにする。
  VALID_EMAIL_DOMAIN = "gmail.com".freeze

  validates :email, presence: true, uniqueness: true, email: true
  validate :valid_email_domain

  class << self
    # Google OAuthにより取得したAUTHデータを元に認証処理を行うメソッド
    def authenticate_by_google_omniauth_info!(google_omniauth_info)
      admin_user = Admin::User.where(uid: [nil, google_omniauth_info["uid"]])
                              .find_by!(email: google_omniauth_info["info"]["email"])

      # uidが未登録の場合は、取得したuidを登録する
      admin_user.update!(uid: google_omniauth_info["uid"]) if admin_user.uid.nil?
      admin_user
    end
  end

  private

  def valid_email_domain
    if email.present? && !email.end_with?("@#{VALID_EMAIL_DOMAIN}")
      errors.add(:email, "許可されていないメールアドレスです")
    end
  end
end
