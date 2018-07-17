# == Schema Information
#
# Table name: user_auth_logs # ユーザーのアカウント認証記録が格納されるテーブル
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null              # ユーザーID(FK)
#  success    :boolean          not null              # ユーザー認証が成功したか失敗を判した結果が反映されるテーブル
#  created_at :datetime         not null
#

class UserAuthLog < ApplicationRecord
  belongs_to :user
  validates :success, presence: true
end
