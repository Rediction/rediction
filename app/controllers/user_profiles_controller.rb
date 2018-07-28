class UserProfilesController < ApplicationController
  before_action :get_provisional_user, only: [:new]

  def new
    @user_profile = UserProfile.new
    @user = User.new(email: @provisional_user.email, password: @provisional_user.password_digest)
    @user.save
    @user_auth_log = UserAuthLog.new(user_id: @user.id, success: true)
    @user_auth_log.save
    @provisional_user_completed_log = ProvisionalUserCompletedLog.new(
      user_id: @user.id,
      provisional_user_id: @provisional_user.id
      )
    @provisional_user_completed_log.save
    @user_change = UserChange.create_from_original!(original_record: @user, event: 'create')
    @user_change.save
  end

  def create

  end

  def get_provisional_user
    @provisional_user = ProvisionalUser.find_by(verification_token: params[:verification_token])
  end
end
