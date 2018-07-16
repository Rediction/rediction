class UserUnfreezedReason < ApplicationRecord
  validates :description,           presence: true
end
