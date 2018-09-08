# == Schema Information
#
# Table name: user_remember_me_tokens # ユーザーのRemember Me機能に利用するトークン
#
#  id           :bigint(8)        not null, primary key
#  user_id      :bigint(8)        not null              # ユーザーID(FK)
#  token_digest :string(255)      not null              # 認証用トークン
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class User::RememberMeToken < ApplicationRecord
  include PerformableWithChanges

  attr_accessor :remember_token

  belongs_to :user
  validates :user_id, uniqueness: true
  validates :token_digest, presence: true

  # 渡されたトークンがダイジェストと一致したらtrueを返却
  def authenticated?(remember_token)
    BCrypt::Password.new(token_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄
  def forget
    destroy_with_changes!
  end

  # 永続認証用のトークンを更新
  def update_token
    self.remember_token = User::RememberMeToken.generate_token
    update_with_changes!(token_digest: User::RememberMeToken.generate_digest(remember_token))
    remember_token
  end

  class << self
    # 永続認証用のトークンを保存
    def remember(user)
      raise if user.remember_me_token

      token = generate_token
      create_with_changes!(user_id: user.id, token_digest: generate_digest(token))
      token
    end

    # トークンをハッシュ化
    def generate_digest(token)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(token, cost: cost)
    end

    # トークンを生成
    def generate_token
      SecureRandom.uuid
    end
  end
end
