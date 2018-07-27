class ApplicationMailer < ActionMailer::Base
  #TODO (shuji ota) : サービスを開始する前にdefaultのメールを変更する
  default from: "from@example.com"
  layout "mailer"
end
