# == Schema Information
#
# Table name: users # ユーザー情報
#
#  id              :bigint(8)        not null, primary key
#  email           :string(255)      not null                 # メールアドレス
#  password_digest :string(255)      not null                 # パスワード
#  freezed         :boolean          default(FALSE), not null # 凍結状態
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  has_secure_password
  has_one :user_profile, dependent: :destroy
  has_one :provisional_user_completed_log, dependent: :destroy
  has_many :user_freezed_reasons, dependent: :destroy
  has_many :user_unfreezed_reasons, dependent: :destroy
  has_many :user_auth_logs, dependent: :destroy

  # TODO(shuji ota):形式チェックのvalidationを追加する
  validates :email, presence: true, uniqueness: true

  # TODO(shuji ota):形式チェックのvalidationを追加する
  validates :password_digest, presence: true

  class << self
    # 会員を_changesテーブルとともに作るメソッド
    def create_with_changes!(email:, password_digest:)
      ActiveRecord::Base.transaction do
        user = create!(email: email, password_digest: password_digest)
        UserChange.create_from_original!(original_record: user, event: "create")
        user
      end
    end

    # 本会員登録を完了させるメソッド
    def complete_registration(provisional_user)
      ActiveRecord::Base.transaction do
        user = create_with_changes!(email: provisional_user.email, password_digest: provisional_user.password_digest)
        ProvisionalUserCompletedLog.create!(user_id: user.id, provisional_user_id: provisional_user.id)
        user
      end
    end

    # インスタンスに格納されてるemailがすでにuserに登録されてるものかどうかを判定するメソッド
    def signuped_email?(provisional_user)
      exists?(email: provisional_user.email)
    end

    # TODO(shuji ota):URLについているトークンが期限切れでないかを確かめるメソッドを作成
  end
end


