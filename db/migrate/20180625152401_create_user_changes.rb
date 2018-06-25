class CreateUserChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :user_changes do |t|
      t.bigint :user_id
      t.bigint :email
      t.string :password

      t.timestamps
    end
  end
end
