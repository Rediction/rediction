# == Schema Information
#
# Table name: user_changes # ユーザー情報更新履歴
#
#  id              :bigint(8)        not null, primary key
#  user_id         :bigint(8)        not null              # 更新したユーザーのID
#  email           :string(255)      not null              # 更新したメールアドレス
#  password_digest :string(255)      not null              # 更新されたパスワード
#  freezed         :boolean          not null              # 凍結状態
#  event           :string(255)      not null              # レコード登録時のイベント
#  created_at      :datetime         not null
#

class UserChange < ApplicationRecord
  has_secure_password
  belongs_to :user
  validates :event, presence: true
end
