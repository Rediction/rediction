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
end
