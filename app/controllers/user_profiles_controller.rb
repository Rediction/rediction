
  class UserProfilesController < ApplicationController
    before_action :new, :user_params


    def new

      @provisional_user = ProvisionalUser.find_by(verification_token: params[:verification_token])

      if @provisional_user.verification_token == params[:verification_token]
        @user = ProvisionalUser.new(id: @provisional_user.id, email: @provisional_user.email, password: @provisional_user.password)
        @user.save
        session[:user_id] = @user.id
      else
        redirect_to new_provisional_user_path
      end
    end

    def creation
      @user_profile = UserProfile.new

    end

    def create
      @user = User.find_by(id: )
      @user_profile = UserProfile.new(user_profile_params)

      if @user_profile.save
        redirect_to users_path
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
