class UserAuthLog < ApplicationRecord
  validates :success,           presence: true
end