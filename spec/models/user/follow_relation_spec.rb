# == Schema Information
#
# Table name: user_follow_relations # ユーザーのフォロー関係
#
#  id                :bigint(8)        not null, primary key
#  following_user_id :bigint(8)        not null              # フォローしているユーザーID
#  followed_user_id  :bigint(8)        not null              # フォローされているユーザーID
#  created_at        :datetime         not null
#

require "rails_helper"

RSpec.describe User::FollowRelation, type: :model do
  include_context 'Changesテーブルを有する場合', User::FollowRelation
end
