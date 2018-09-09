class Admin::Dashboard::Transition::FollowsController < Admin::ApplicationController
  include Admin::DateHandler

  # フォロー数の推移
  def follow
    seed = ::User::FollowRelation.select("date(user_follow_relations.created_at) as date_at")
                                 .select("count(user_follow_relations.id) as follow_count")
                                 .group("date_at")
                                 .order("date_at")
                                 .limit(100)

    start_date, end_date = fetch_target_period_dates(params[:start_date], params[:end_date])

    seed = seed.where("user_follow_relations.created_at >= ?", start_date)
    seed = seed.where("user_follow_relations.created_at <= ?", end_date)

    rows = excute_sql(seed)
    daily_count_hash = array_to_daily_hash(rows, "follow_count")

    # 件数が0件の日にちは取得できずに歯抜けになるので、その分のkeyを埋める
    @daily_counts = fill_missing_date_with_zero(daily_count_hash, start_date, end_date)
  end
end
