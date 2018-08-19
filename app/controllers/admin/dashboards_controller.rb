class Admin::DashboardsController < Admin::ApplicationController
  def show
    @users_count = ::User.count
    @words_count = ::Word.count
    @favorites_count = ::Favorite.count
  end
end
