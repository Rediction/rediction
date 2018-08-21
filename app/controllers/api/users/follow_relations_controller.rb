class Api::Users::FollowRelationsController < Api::SecureApplicationController
  # 一回のアクセスで取得するレコードの数
  FETCH_COUNT = 10

  # フォローユーザー一覧を取得
  def index
    @follow_relations = ::User::FollowRelation.find_latest_relations_by_following_user_id(
      limit: FETCH_COUNT,
      following_user_id: params[:user_id],
      max_fetched_id: params[:last_fetched_id],
    )
  end
end
