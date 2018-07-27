class ProvisionalUserRegistrationMailer < ApplicationMailer
  #TODO (shuji ota) : サービスを開始する前にdefaultのメールを変更する
  default from: "shujiota723@gmail.com"

  # 本会員登録の認証用メールを送信する処理
  def send_when_registration(provisional_user)
    @provisional_user = provisional_user
    mail to: @provisional_user.email, subject: "メール認証"
  end
end
