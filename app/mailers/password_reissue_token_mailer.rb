class PasswordReissueTokenMailer < ApplicationMailer
  # 本会員登録の認証用メールを送信する処理
  def send_url_to_reissue(password_reissue_token)
    @password_reissue_token = password_reissue_token
    mail to: @password_reissue_token.email, subject: "パスワード再発行 | Rediction"
  end
end
