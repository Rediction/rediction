class User::LoginForm
  include ActiveModel::Model

  attr_accessor :email, :password, :user

  # ユーザーのパスワード再設定処理
  def authenticate
    # paramsで取得したメールアドレスからユーザーを特定する
    self.user = User.find_by(email: email)

    # パスワードに誤りがあった場合はfalseを返却
    return false unless user&.authenticate(password)

    user
  end
end
