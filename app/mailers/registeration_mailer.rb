class RegisterationMailer < ApplicationMailer
  default from: 'shujiota723@gmail.com'
# 仮会員登録が完了したらメールも仮ユーザーに送るもの
  def send_when_registeration(provisional_user)
    @provisional_user = provisional_user
    @url = "http://localhost:3000/user_profiles/create?verification_token=#{@provisional_user.verification_token}"
    mail to: @provisional_user.email, subject: "メール認証"
  end
end