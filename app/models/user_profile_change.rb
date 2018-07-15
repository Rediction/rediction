class UserProfileChange < ApplicationRecord

  validates :event, presence: true
end