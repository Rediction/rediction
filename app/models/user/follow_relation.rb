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
    # 最新のレコードを取得
    # 第三引数(max_fetched_id)で取得する最大のIDを指定可能。
    def find_latest_relations_by_following_user_id(limit: 10, following_user_id:, max_fetched_id: nil)
      follow_relations =
        includes(followed_user: :profile).where(following_user_id: following_user_id).order(id: :desc).limit(limit)

      # 最後に取得したIDがparamsに含まれている場合、それより前のIDを取得するように条件を追加
      if max_fetched_id.present?
        follow_relations = follow_relations.where("user_follow_relations.id < ?", max_fetched_id)
      end

      follow_relations
    end

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
