class AddFavoriteIdToFavoriteChange < ActiveRecord::Migration[5.2]
  def change
    add_column :favorite_changes, :favorite_id, :bigint, null: false, after: :id, comment: 'お気に入りID'
  end
end
