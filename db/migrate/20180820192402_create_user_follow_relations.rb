class CreateUserFollowRelations < ActiveRecord::Migration[5.2]
  def change
    create_table :user_follow_relations, comment: "ユーザーのフォロー関係" do |t|
      t.references :following_user, null: false, foreign_key: { to_table: :users }, index: true, comment: "フォローしているユーザーID"
      t.references :followed_user, null: false, foreign_key: { to_table: :users }, index: true, comment: "フォローされているユーザーID"
      t.datetime :created_at, null: false
    end
  end
end
