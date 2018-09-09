class Admin::Dashboard::Ranking::WordsController < Admin::ApplicationController
  # お気に入りされている数の多い言葉ランキング
  def favorited
    seed = ::Word.select("words.id as word_id")
                 .select("words.name as word_name")
                 .select("words.description as word_description")
                 .select("count(favorites.id) as favorite_count")
                 .select("concat(user_profiles.last_name, user_profiles.first_name) as full_name")
                 .eager_load(user: :profile)
                 .joins(:favorites)
                 .group("words.id")
                 .order("favorite_count desc")
                 .limit(50)

    seed = seed.where("users.created_at >= ?", params[:user_start_date]) if params[:user_start_date].present?
    seed = seed.where("users.created_at <= ?", params[:user_end_date]) if params[:user_end_date].present?
    seed = seed.where("words.created_at >= ?", params[:word_start_date]) if params[:word_start_date].present?
    seed = seed.where("words.created_at <= ?", params[:word_end_date]) if params[:word_end_date].present?

    @rows = excute_sql(seed)
  end
end
