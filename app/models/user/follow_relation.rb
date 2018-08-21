# == Schema Information
#
# Table name: user_follow_relations # ユーザーのフォロー関係
#
#  id                :bigint(8)        not null, primary key
#  following_user_id :bigint(8)        not null              # フォローしているユーザーID
#  followed_user_id  :bigint(8)        not null              # フォローされているユーザーID
#  created_at        :datetime         not null
#

class User::FollowRelation < ApplicationRecord
  include PerformableWithChanges

  belongs_to :following_user, class_name: "User"
  belongs_to :followed_user, class_name: "User"

  class << self
    # フォローの有無を切り替える処理
    # フォロー中の場合は解除し、フォローしていない場合は新しく登録
    def toggle_follow_status!(following_user_id:, followed_user_id:)
      follow_relation = find_by(following_user_id: following_user_id, followed_user_id: followed_user_id)

      if follow_relation.present?
        # フォローを解除し、nilを返却
        follow_relation.destroy_with_changes!
        nil
      else
        # フォローし、レコードのインスタンスを返却
        create_with_changes!(following_user_id: following_user_id, followed_user_id: followed_user_id)
      end
    end
  end
end
