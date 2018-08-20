class User::PasswordReissueForm
  include ActiveModel::Model
  include ActiveModel::SecurePassword
  attr_accessor :password_digest, :token

  has_secure_password

  # TODO(shuji ota):形式チェックのvalidationを追加する
  validates :password, length: (8..32), presence: true, confirmation: true

  # ユーザーのパスワード再設定処理
  def save!
    password_reissue_token = User::PasswordReissueToken.find_by!(token: token)

    # トークン登録時のメールアドレスと現時点のユーザーのメールアドレスが異なる場合は404を表示
    if password_reissue_token.user.email != password_reissue_token.email
      raise ExceptionHandlers::NotFound
    end

    validate!

    ActiveRecord::Base.transaction do
      password_reissue_token.update_with_changes!(consumed: :consumed)
      password_reissue_token.user.update_with_changes!(password_digest: password_digest)
    end
  end
end
