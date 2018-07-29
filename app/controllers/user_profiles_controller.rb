class UserProfilesController < ApplicationController
  before_action :create_user, only: [:new]

  def new
    @user_profile = UserProfile.new
  end

  def create

  end

  def complete_user_registeration
    @provisional_user = ProvisionalUser.find_by(verification_token: params[:verification_token])
    @user = User.new(email: @provisional_user.email, password: @provisional_user.password_digest)
    @user.save
    @user.create_user_data(@user,@provisional_user)
  end
end
