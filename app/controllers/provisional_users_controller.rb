class ProvisionalUsersController < ApplicationController

  def new
    @provisional_user = ProvisionalUser.new
  end

  def create
    @provisional_user = ProvisionalUser.new(provisional_user_params)
    @provisional_user.verification_token = SecureRandom.uuid
    if @provisional_user.save
      RegisterationMailer.send_when_registeration(@provisional_user).deliver_now
      flash[:success] = "登録成功"
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

    def provisional_user_params
      params.require(:provisional_user).permit(:email, :password_digest)
    end

end