class RegisterationMailer < ApplicationMailer

  def send_when_registeration(provisional_user)
    @provisional_user = provisional_user
    @url = "http://localhost:3000/users/create/#{@provisional_user.verification_token}"
    mail to: @provisional_user.email,
         subject: "メール認証"
  end
end