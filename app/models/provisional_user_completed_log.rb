class ProvisionalUserCompletedLog < ApplicationRecord
  validates :user_id,               presence: true
  validates :provisional_user_id,   presence: true
end