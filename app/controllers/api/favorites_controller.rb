class Api::FavoritesController < Api::SecureApplicationController
  protect_from_forgery except: :update

  def update
    @favorite = Favorite.toggle_status!(word_id: params[:word_id], user_id: params[:user_id])

    # wordのお気に入り件数
    @favorite_count = Favorite.where(word_id: params[:word_id]).count
  end
end
