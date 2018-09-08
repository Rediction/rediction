# == Schema Information
#
# Table name: user_remember_me_token_changes # ユーザーのRemember Me機能に利用するトークンの履歴
#
#  id                        :bigint(8)        not null, primary key
#  user_remember_me_token_id :bigint(8)        not null              # Remember MeトークンID
#  user_id                   :bigint(8)        not null              # ユーザーID
#  token_digest              :string(255)      not null              # 認証用トークン
#  event                     :string(255)      not null              # イベント
#  created_at                :datetime         not null
#

class User::RememberMeTokenChange < ApplicationRecord
  include CreatableFromOriginal
  ORIGINAL_FOREIGN_KEY = :user_remember_me_token_id

  validates :user_id, presence: true
  validates :token_digest, presence: true
end
