class ApplicationMailer < ActionMailer::Base
  # TODO (shuji ota) : サービスを開始する前にdefaultのメールを変更する
  default from: "shujiota723@gmail.com"
  layout "mailer"
end
