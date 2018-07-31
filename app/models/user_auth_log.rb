# == Schema Information
#
# Table name: user_auth_logs # ユーザーのアカウント認証記録が格納されるテーブル
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null              # ユーザーID(FK)
#  success    :boolean          not null              # ユーザー認証が成功したか失敗したかを判断した結果が反映されるテーブル
#  created_at :datetime         not null
#

class UserAuthLog < ApplicationRecord
  belongs_to :user
  validates :success, presence: true

  class << self
    # ユーザーの認証成功記録を保存するメソッド
    def save_success_log(user)
       create(user: user, success: true)
    end

    # ユーザーの認証失敗記録を保存するメソッド
    def save_failure_log(user)
       create(user: user, success: false)
    end
  end
end
