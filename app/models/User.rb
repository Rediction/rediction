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
  validates :email, presence: true

  # TODO(shuji ota):形式チェックのvalidationを追加する
  validates :password_digest, presence: true

  class << self
    # ユーザーの本会員登録を完了させるメソッド
    def complete_member_registration(provisional_user)
      ActiveRecord::Base.transaction do
        user = User.create!(email: provisional_user.email, password_digest: provisional_user.password_digest)

        raise ActiveRecord::Rollback unless user
        UserChange.create_from_original!(original_record: user, event: "create")
        user.create_provisional_user_completed_log(provisional_user_id: provisional_user.id)
        UserAuthLog.save_success_log(user)
      end
    end
  end
end
