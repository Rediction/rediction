class UserFreezedReason < ApplicationRecord
  validates :description,           presence: true
end
