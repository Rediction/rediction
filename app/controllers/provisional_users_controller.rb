class ProvisionalUsersController < ApplicationController
  def new
    @provisional_user = ProvisionalUser.new
  end

  def create
    @provisional_user = ProvisionalUser.new(provisional_user_params)

    if @provisional_user.save_with_verification_token
      # ユーザー認証を行い、本会員登録を完了させるためのメール
      RegisterationMailer.send_when_registeration(@provisional_user).deliver_now
    else
      flash[:error] = "failed to register"
      render 'new'
    end
  end

 private

    def provisional_user_params
      params.require(:provisional_user).permit(:email, :password)
    end

end
