class ProvisionalUserRegistrationMailer < ApplicationMailer
  # 本会員登録の認証用メールを送信する処理
  def send_when_registration(provisional_user)
    @provisional_user = provisional_user
    mail to: @provisional_user.email, subject: "仮会員登録 | Rediction"
  end
end
