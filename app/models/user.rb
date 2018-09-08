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
  has_one :remember_me_token, dependent: :destroy

  has_many :freezed_reasons, dependent: :destroy
  has_many :unfreezed_reasons, dependent: :destroy
  has_many :resignation_requests, class_name: "User::Resignation::Request"
  has_many :resignation_request_cancels, class_name: "User::Resignation::RequestCancel"
  has_many :user_auth_logs, dependent: :destroy
  has_many :words, dependent: :destroy
  has_many :password_reissue_tokens, dependent: :destroy
  has_many :follow_relations, dependent: :destroy, foreign_key: :following_user_id
  has_many :followed_relations, dependent: :destroy, class_name: "User::FollowRelation", foreign_key: :followed_user_id
  has_many :favorites, dependent: :destroy

  enum freezed: {freezed: true, unfreezed: false}
  enum resigned: {resigned: true, unresigned: false}

  validates :email, presence: true, uniqueness: true, email: true

  # TODO(shuji ota):形式チェックのvalidationを追加する
  validates :password, length: (8..32), presence: true, confirmation: true, allow_nil: true
  validates :password_confirmation, presence: true, allow_nil: true

  # 稼働中のアカウント(未凍結 & 退会していない)
  scope :active, -> { unfreezed.unresigned }

  # 言葉(引数)がお気に入り登録中の言葉かどうかを判定
  def favorite_word?(word)
    favorites.exists?(word_id: word.id)
  end

  # ユーザー(引数)がフォロー中のユーザーかどうかを判定
  def followed_user?(user)
    follow_relations.exists?(followed_user_id: user.id)
  end

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
