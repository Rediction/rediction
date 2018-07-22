module User
  class UserProfilesController < ApplicationController
    before_action :new, :user_params


    def new
      @user_profile = UserProfile.new

      @provisional_user = ProvisionalUser.find_by(email: params[:email])

      if @provisional_user.verification_token == params[:verification_token]
        @user = User.new(user_params)
        @user.save
      else
        redirect_to  new_provisional_user_path
      end
    end

    def create

      @user_profile = UserProfile.new(user_profile_params)

      if @user_profile.save
        redirect_to users_path
      else
        falsh[:error] = "failed"
        render 'new'
      end
    end

    private

      def user_profile_params
        params.require(:user_profile).permit(:last_name, :last_name_kana, :first_name, :first_name_kana, :birth_on, :job)
      end

      def user_params
        sparams.require(:user).permit(:email, :password)
      end

  end
end