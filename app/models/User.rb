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

  validates :email, presence: true
  validates :password_digest, presence: true

  class << self
    # 会員登録の処理を行うメソッド
    def save_provisional_user_completion_log(provisional_user)
      ActiveRecord::Base.transaction do
        user = User.create(email: provisional_user.email, password_digest: provisional_user.password_digest)

        return render text: "正しく処理が行われませんでした" unless user.email != nil || user.password_digest != nil
        user.create_provisional_user_completed_log(provisional_user_id: provisional_user.id)
        UserChange.create_from_original!(original_record: user, event: 'create')

        # TODO (shuji ota):この処理が行われるタイミングでログインの処理が行われるようにする
        UserAuthLog.save_success_log(user)
      end
    end
  end
end
