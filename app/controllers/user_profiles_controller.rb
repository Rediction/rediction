
  class UserProfilesController < ApplicationController

    def new
      @user_profile = UserProfile.new
      @verification_token = params[:verification_token]
      @provisional_user = ProvisionalUser.find_by(verification_token: @verification_token)
      if @provisional_user
        @user = User.new(email: @provisional_user.email, password: @provisional_user.password)
        @user.save
        @user_change = UserChange.new(email: @provisional_user.email, password_digest: @provisional_user.password, event: "created")
        @user_change.save
      end
    end

    def create
      @user_profile = UserProfile.new(user_profile_params)

      if @user_profile.save
        redirect_to users_index
      else
        flash[:error] = "failed"
        render 'new'
      end
    end

    private

      def user_profile_params
        params.require(:user_profile).permit(:last_name, :last_name_kana, :first_name, :first_name_kana, :birth_on, :job)
      end
  end
