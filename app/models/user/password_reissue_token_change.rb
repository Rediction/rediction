# == Schema Information
#
# Table name: user_password_reissue_token_changes # ユーザー用のパスワード再発行用トークンの履歴
#
#  id                             :bigint(8)        not null, primary key
#  user_password_reissue_token_id :bigint(8)        not null                        # 再発行用トークンID
#  user_id                        :bigint(8)        not null                        # ユーザーID(FK)
#  email                          :string(255)      not null                        # メールアドレス
#  token                          :string(255)      not null                        # トークン
#  consumed                       :boolean          default("unconsumed"), not null # 利用済み
#  event                          :string(255)      not null                        # イベント
#  created_at                     :datetime         not null
#

class User::PasswordReissueTokenChange < ApplicationRecord
  include CreatableFromOriginal
  ORIGINAL_FOREIGN_KEY = :user_password_reissue_token_id

  enum consumed: {consumed: true, unconsumed: false}
end
