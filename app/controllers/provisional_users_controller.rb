class ProvisionalUsersController < ApplicationController

  def new
    @provisional_user = ProvisionalUser.new
  end

  def create
    @provisional_user = ProvisionalUser.new(provisional_user_params)
    @provisional_user.verification_token = SecureRandom.uuid

    if @provisional_user.save
      # RegisterationMailer.send_when_registeration(@provisional_user).deliver
      redirect_to provisional_users_creation_path
    else
      flash[:error] = "failed"
      render 'new'
    end
  end

  def creation
    @provisional_users = ProvisionalUser.all.order(created_at: :desc)
    # @provisional_user = ProvisionalUser.find_by(email: params[:provisional_user][:email])
  end

  private

    def provisional_user_params
      params.require(:provisional_user).permit(:email, :password)
    end

end