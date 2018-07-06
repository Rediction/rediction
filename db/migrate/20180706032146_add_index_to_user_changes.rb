class AddIndexToUserChanges < ActiveRecord::Migration[5.2]
  def change
    add_index :user_changes, :user_id
  end
end
