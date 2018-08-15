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
  has_secure_password
  has_one :profile, dependent: :destroy, class_name: "UserProfile"
  has_one :provisional_user_completed_log, dependent: :destroy
  has_many :freezed_reasons, dependent: :destroy
  has_many :unfreezed_reasons, dependent: :destroy
  has_many :resignation_requests, class_name: "User::Resignation::Request"
  has_many :resignation_request_cancels, class_name: "User::Resignation::RequestCancel"
  has_many :user_auth_logs, dependent: :destroy

  enum freezed: {freezed: true, unfreezed: false}
  enum resigned: {resigned: true, unresigned: false}

  validates :email, presence: true, uniqueness: true, email: true

  # TODO(shuji ota):形式チェックのvalidationを追加する
  validates :password_digest, presence: true

  # 稼働中のアカウント(未凍結 & 退会していない)
  scope :active, -> { unfreezed.unresigned }

  # ユーザーデータを更新して、changesテーブルを作成するメソッド
  # TODO(Shokei Takanashi) : changesテーブルを有する全Modelにこのメソッドが書かれるのは単調なので、あとでModule化する。
  def update_with_changes!(attributes)
    ActiveRecord::Base.transaction do
      update!(attributes)
      UserChange.create_from_original!(original_record: self, event: "update")
      self
    end
  end

  class << self
    # 会員テーブルをchangesテーブルとともに作成するメソッド
    def create_with_changes!(email:, password_digest:)
      ActiveRecord::Base.transaction do
        user = create!(email: email, password_digest: password_digest)
        UserChange.create_from_original!(original_record: user, event: "create")
        user
      end
    end

    # 会員登録を完了させるメソッド
    def complete_member_registration!(provisional_user)
      ActiveRecord::Base.transaction do
        user = create_with_changes!(email: provisional_user.email, password_digest: provisional_user.password_digest)

        # usersテーブルとprovisional_usersテーブルの結び付き関係を格納する
        ProvisionalUserCompletedLog.create!(user_id: user.id, provisional_user_id: provisional_user.id)
        user
      end
    end
  end
end
