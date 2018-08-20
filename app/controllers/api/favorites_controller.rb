class Api::FavoritesController < Api::SecureApplicationController
  protect_from_forgery except: :update

  def update
    @favorite = Favorite.toggleStatus!(word_id: params[:word_id], user_id: params[:user_id])
  end
end
