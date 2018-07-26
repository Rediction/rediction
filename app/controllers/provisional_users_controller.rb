class ProvisionalUsersController < ApplicationController
  def new
    @provisional_user = ProvisionalUser.new
  end

  def create

    provisional_user = ProvisionalUser.new(provisional_user_params)
    provisional_user.save_with_verification_token

    if provisional_user
      RegisterationMailer.send_when_registeration(provisional_user).deliver_now
    else
      flash[:error] = "failed"
      render 'new'
    end
  end

 private

    def provisional_user_params
      params.require(:provisional_user).permit(:email, :password)
    end

end