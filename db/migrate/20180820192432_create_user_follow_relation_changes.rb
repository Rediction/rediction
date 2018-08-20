class CreateUserFollowRelationChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :user_follow_relation_changes, comment: "ユーザーのフォロー関係の履歴" do |t|
      t.bigint :user_follow_relation_id, null: false, comment: "フォロー関係ID"
      t.references :following_user, null: false, foreign_key: { to_table: :users }, index: true, comment: "フォローしているユーザーID"
      t.references :followed_user, null: false, foreign_key: { to_table: :users }, index: true, comment: "フォローされているユーザーID"
      t.string :event, null: false, comment: "レコード登録時のイベント"
      t.datetime :created_at, null: false
    end
  end
end
