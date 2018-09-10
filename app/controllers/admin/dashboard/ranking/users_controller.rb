# Adminでしか利用しない特殊なロジックが多いので、基本的にはModelには切り出さない方針でやっている。
# 今後ControllerがFatになるようなら、それぞれ別Controllerのクラスとして切り分けるなり対応する。
class Admin::Dashboard::Ranking::UsersController < Admin::ApplicationController
  # お気に入りされている言葉の多いユーザーランキング
  def favorited_words
    seed = ::User.select("users.id as user_id")
                 .select("count(favorites.id) as favorite_count")
                 .select("concat(user_profiles.last_name, user_profiles.first_name) as full_name")
                 .eager_load(:profile)
                 .joins(words: :favorites)
                 .group("users.id")
                 .order("favorite_count desc")
                 .limit(50)

    seed = seed.where("words.created_at >= ?", params[:word_start_date]) if params[:word_start_date].present?
    seed = seed.where("words.created_at <= ?", params[:word_end_date]) if params[:word_end_date].present?
    if params[:favorite_start_date].present?
      seed = seed.where("favorites.created_at >= ?", params[:favorite_start_date])
    end
    seed = seed.where("favorites.created_at <= ?", params[:favorite_end_date]) if params[:favorite_end_date].present?

    @rows = excute_sql(seed)
  end

  # お気に入りしている言葉の多いユーザーランキング
  def favoriting_words
    seed = ::User.select("users.id as user_id")
                 .select("count(favorites.id) as favorite_count")
                 .select("concat(user_profiles.last_name, user_profiles.first_name) as full_name")
                 .eager_load(:profile)
                 .joins(:favorites)
                 .group("users.id")
                 .order("favorite_count desc")
                 .limit(50)

    seed = seed.where("words.created_at >= ?", params[:word_start_date]) if params[:word_start_date].present?
    seed = seed.where("words.created_at <= ?", params[:word_end_date]) if params[:word_end_date].present?
    if params[:favorite_start_date].present?
      seed = seed.where("favorites.created_at >= ?", params[:favorite_start_date])
    end
    seed = seed.where("favorites.created_at <= ?", params[:favorite_end_date]) if params[:favorite_end_date].present?

    @rows = excute_sql(seed)
  end

  # 投稿数の多いユーザーランキング
  def posted_words
    seed = ::User.select("users.id as user_id")
                 .select("count(words.id) as word_count")
                 .select("concat(user_profiles.last_name, user_profiles.first_name) as full_name")
                 .eager_load(:profile)
                 .joins(:words)
                 .group("users.id")
                 .order("word_count desc")
                 .limit(50)

    seed = seed.where("users.created_at >= ?", params[:user_start_date]) if params[:user_start_date].present?
    seed = seed.where("users.created_at <= ?", params[:user_end_date]) if params[:user_end_date].present?
    seed = seed.where("words.created_at >= ?", params[:word_start_date]) if params[:word_start_date].present?
    seed = seed.where("words.created_at <= ?", params[:word_end_date]) if params[:word_end_date].present?

    @rows = excute_sql(seed)
  end

  # フォロワー数の多いユーザーランキング
  def followed
    seed = ::User.select("users.id as user_id")
                 .select("count(user_follow_relations.id) as followed_count")
                 .select("concat(user_profiles.last_name, user_profiles.first_name) as full_name")
                 .eager_load(:profile)
                 .joins(:followed_relations)
                 .group("users.id")
                 .order("followed_count desc")
                 .limit(50)

    seed = seed.where("users.created_at >= ?", params[:user_start_date]) if params[:user_start_date].present?
    seed = seed.where("users.created_at <= ?", params[:user_end_date]) if params[:user_end_date].present?
    if params[:followed_start_date].present?
      seed = seed.where("user_follow_relations.created_at >= ?", params[:followed_start_date])
    end
    if params[:followed_end_date].present?
      seed = seed.where("user_follow_relations.created_at <= ?", params[:followed_end_date])
    end

    @rows = excute_sql(seed)
  end

  # フォロー数の多いユーザーランキング
  def following
    seed = ::User.select("users.id as user_id")
                 .select("count(user_follow_relations.id) as follow_count")
                 .select("concat(user_profiles.last_name, user_profiles.first_name) as full_name")
                 .eager_load(:profile)
                 .joins(:follow_relations)
                 .group("users.id")
                 .order("follow_count desc")
                 .limit(50)

    seed = seed.where("users.created_at >= ?", params[:user_start_date]) if params[:user_start_date].present?
    seed = seed.where("users.created_at <= ?", params[:user_end_date]) if params[:user_end_date].present?
    if params[:follow_start_date].present?
      seed = seed.where("user_follow_relations.created_at >= ?", params[:follow_start_date])
    end
    if params[:follow_end_date].present?
      seed = seed.where("user_follow_relations.created_at <= ?", params[:follow_end_date])
    end

    @rows = excute_sql(seed)
  end
end
