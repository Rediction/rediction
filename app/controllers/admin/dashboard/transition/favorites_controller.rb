class Admin::Dashboard::Transition::FavoritesController < Admin::ApplicationController
  include Admin::DateHandler

  # お気に入り数の推移
  def favorite
    seed = ::Favorite.select("date(favorites.created_at) as date_at")
                     .select("count(favorites.id) as favorite_count")
                     .group("date_at")
                     .order("date_at")
                     .limit(100)

    start_date, end_date = fetch_target_period_dates(params[:start_date], params[:end_date])

    seed = seed.where("favorites.created_at >= ?", start_date)
    seed = seed.where("favorites.created_at <= ?", end_date)

    rows = excute_sql(seed)
    daily_count_hash = array_to_daily_hash(rows, "favorite_count")

    # 件数が0件の日にちは取得できずに歯抜けになるので、その分のkeyを埋める
    @daily_counts = fill_missing_date_with_zero(daily_count_hash, start_date, end_date)
  end
end
