# == Schema Information
#
# Table name: user_follow_relation_changes # ユーザーのフォロー関係の履歴
#
#  id                      :bigint(8)        not null, primary key
#  user_follow_relation_id :bigint(8)        not null              # フォロー関係ID
#  following_user_id       :bigint(8)        not null              # フォローしているユーザーID
#  followed_user_id        :bigint(8)        not null              # フォローされているユーザーID
#  event                   :string(255)      not null              # レコード登録時のイベント
#  created_at              :datetime         not null
#

class User::FollowRelationChange < ApplicationRecord
  include CreatableFromOriginal
  ORIGINAL_FOREIGN_KEY = :user_follow_relation_id
end
