class Api::User::FollowRelationsController < Api::SecureApplicationController
  protect_from_forgery except: :update

  def update
    @follow_relation = User::FollowRelation.toggle_follow_status!(
      following_user_id: params[:following_user_id],
      followed_user_id: params[:followed_user_id],
    )
  end
end
