# == Schema Information
#
# Table name: users # ユーザー情報
#
#  id              :bigint(8)        not null, primary key
#  email           :string(255)      not null                        # メールアドレス
#  password_digest :string(255)      not null                        # パスワード
#  freezed         :boolean          default("unfreezed"), not null  # 凍結状態
#  resigned        :boolean          default("unresigned"), not null # 退会状態
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  include PerformableWithChanges

  has_secure_password

  has_one :profile, dependent: :destroy, class_name: "UserProfile"
  has_one :provisional_user_completed_log, dependent: :destroy
  has_many :freezed_reasons, dependent: :destroy
  has_many :unfreezed_reasons, dependent: :destroy
  has_many :resignation_requests, class_name: "User::Resignation::Request"
  has_many :resignation_request_cancels, class_name: "User::Resignation::RequestCancel"
  has_many :user_auth_logs, dependent: :destroy
  has_many :words, dependent: :destroy
  has_many :password_reissue_tokens, dependent: :destroy
  has_many :follow_relations, dependent: :destroy

  enum freezed: {freezed: true, unfreezed: false}
  enum resigned: {resigned: true, unresigned: false}

  validates :email, presence: true, uniqueness: true, email: true

  # TODO(shuji ota):形式チェックのvalidationを追加する
  validates :password, length: (8..32), presence: true, unless: :password_digest

  # 稼働中のアカウント(未凍結 & 退会していない)
  scope :active, -> { unfreezed.unresigned }

  class << self
    # 会員登録を完了させるメソッド
    def complete_member_registration!(provisional_user)
      ActiveRecord::Base.transaction do
        user = create_with_changes!({email: provisional_user.email, password_digest: provisional_user.password_digest})

        # usersテーブルとprovisional_usersテーブルの結び付き関係を格納する
        ProvisionalUserCompletedLog.create!(user_id: user.id, provisional_user_id: provisional_user.id)
        user
      end
    end
  end
end
