# == Schema Information
#
# Table name: user_resignation_requests # ユーザーの退会申請が格納されるテーブル
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null              # ユーザーID
#  description :string(255)      not null              # 凍結解除理由
#  created_at  :datetime         not null
#

class User::Resignation::Request < ApplicationRecord
  self.table_name = "user_resignation_requests"

  belongs_to :user
  validates :description, presence: true, length: {maximum: 140}

  # レコードを保存して、リレーションのあるユーザーを退会させるメソッド
  def save_and_resign_user!
    ActiveRecord::Base.transaction do
      save!
      user.update_with_changes!(resigned: :resigned)
      self
    end
  end
end
