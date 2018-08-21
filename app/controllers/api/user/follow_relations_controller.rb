class Api::User::FollowRelationsController < Api::SecureApplicationController
  protect_from_forgery except: :update

  # 一回のアクセスで取得するレコードの数
  FETCH_COUNT = 10

  # フォローユーザー一覧を取得
  def index
    @follow_relations = ::User::FollowRelation.find_latest_relations_by_following_user_id(
      limit: FETCH_COUNT,
      following_user_id: params[:following_user_id],
      max_fetched_id: params[:last_fetched_id],
    )
  end

  # フォローステータスを更新
  def update
    @follow_relation = User::FollowRelation.toggle_follow_status!(
      following_user_id: params[:following_user_id],
      followed_user_id: params[:followed_user_id],
    )
  end
end
