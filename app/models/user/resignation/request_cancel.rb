# == Schema Information
#
# Table name: user_resignation_request_cancels # ユーザーの退会申請のキャンセルが格納されるテーブル
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null              # ユーザーID
#  description :string(255)      not null              # 退会キャンセル理由
#  created_at  :datetime         not null
#

class User::Resignation::RequestCancel < ApplicationRecord
  self.table_name = "user_resignation_request_cancels"

  belongs_to :user
  validates :description, presence: true, length: {maximum: 140}

  # レコードを保存して、リレーションのあるユーザーの退会をキャンセルするメソッド
  def save_and_cancel_resign_request!
    ActiveRecord::Base.transaction do
      save!
      user.update_with_changes!(resigned: :unresigned)
      self
    end
  end
end
