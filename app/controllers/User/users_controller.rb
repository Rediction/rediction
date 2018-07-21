module User
  class UsersController < ApplicationController

    def create
      @provisional_user = ProvisionalUser.find_by(id: params[:id])

      if @provisional_user.verification_token == params[:verification_token]
        @user = User.new(user_params)
        @user.save
        redirect_to new_user_profile_path
      else
        redirect_to  new_provisional_user_path
      end
    end

    private

      def user_params
        params.require(:user).permit(:email, :password_digest)
      end

  end
end
