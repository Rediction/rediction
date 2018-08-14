# == Schema Information
#
# Table name: user_changes # ユーザー情報更新履歴
#
#  id              :bigint(8)        not null, primary key
#  user_id         :bigint(8)        not null                        # 更新したユーザーのID
#  email           :string(255)      not null                        # 更新したメールアドレス
#  password_digest :string(255)      not null                        # 更新されたパスワード
#  freezed         :boolean          not null                        # 凍結状態
#  resigned        :boolean          default("unresigned"), not null # 退会状態
#  event           :string(255)      not null                        # レコード登録時のイベント
#  created_at      :datetime         not null
#

class UserChange < ApplicationRecord
  include CreatableFromOriginal
  ORIGINAL_FOREIGN_KEY = :user_id

  belongs_to :user

  enum freezed: {freezed: true, unfreezed: false}
  enum resigned: {resigned: true, unresigned: false}
end
