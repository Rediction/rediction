# == Schema Information
#
# Table name: user_follow_relations # ユーザーのフォロー関係
#
#  id                :bigint(8)        not null, primary key
#  following_user_id :bigint(8)        not null              # フォローしているユーザーID
#  followed_user_id  :bigint(8)        not null              # フォローされているユーザーID
#  created_at        :datetime         not null
#

FactoryBot.define do
  factory :user_follow_relation, class: User::FollowRelation do
    association :following_user, factory: :user
    association :followed_user, factory: :user
  end
end
