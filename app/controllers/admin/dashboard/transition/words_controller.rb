class Admin::Dashboard::Transition::WordsController < Admin::ApplicationController
  include Admin::DateHandler

  # 言葉の投稿数の推移
  def posted
    seed = ::Word.select("date(words.created_at) as date_at")
                 .select("count(words.id) as word_count")
                 .group("date_at")
                 .order("date_at")
                 .limit(100)

    start_date, end_date = fetch_target_period_dates(params[:start_date], params[:end_date])

    seed = seed.where("words.created_at >= ?", start_date)
    seed = seed.where("words.created_at <= ?", end_date)

    rows = excute_sql(seed)
    daily_count_hash = array_to_daily_hash(rows, "word_count")

    # 件数が0件の日にちは取得できずに歯抜けになるので、その分のkeyを埋める
    @daily_counts = fill_missing_date_with_zero(daily_count_hash, start_date, end_date)
  end
end
