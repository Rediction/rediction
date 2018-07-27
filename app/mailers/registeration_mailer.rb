class RegisterationMailer < ApplicationMailer
  default from: 'shujiota723@gmail.com'

  # 仮会員登録が完了したらメールも仮ユーザーに送るもの
  def send_when_registeration(provisional_user)
    @provisional_user = provisional_user
    mail to: @provisional_user.email, subject: "メール認証"
  end
end
  