class Admin::DashboardsController < Admin::ApplicationController
  def show
    @users_count = ::User.count

    # TODO(Shokei Takanashi)
    # WordとFavoriteそれぞれを実装した後に、コメントアウトを外して、それぞれの総数を表示するように改修する
    # @words_count = ::Word.count
    # @favorites_count = ::Favorite.count
  end
end
