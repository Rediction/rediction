module User
  class UserProfilesController < ApplicationController

    def new
      @user_profile = UserProfile.new
    end

    def create

      @user_profile = UserProfile.new(user_id: params[:id], user_profile_params)

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

  end
end