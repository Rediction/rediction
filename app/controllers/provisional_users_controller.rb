class ProvisionalUsersController < ApplicationController
  def new
    @provisional_user = ProvisionalUser.new
  end

  def create
  p "-----------------------------"
    p provisional_user = ProvisionalUser.new(provisional_user_params)
    p provisional_user.save
    exit
  end

 private

    def provisional_user_params
      params.require(:provisional_user).permit(:email, :password)
    end

end