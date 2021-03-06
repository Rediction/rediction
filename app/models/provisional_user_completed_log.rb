# == Schema Information
#
# Table name: provisional_user_completed_logs # usersテーブルとprovisional_usersテーブルの結び付き関係を格納
#
#  id                  :bigint(8)        not null, primary key
#  user_id             :bigint(8)        not null              # ユーザーID(FK)
#  provisional_user_id :bigint(8)        not null              # 仮ユーザーID(FK)
#  created_at          :datetime         not null
#

class ProvisionalUserCompletedLog < ApplicationRecord
  belongs_to :user
  belongs_to :provisional_user
end
