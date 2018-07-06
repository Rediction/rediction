# == Schema Information
#
# Table name: user_changes
#
#  id              :bigint(8)        not null, primary key
#  user_id         :bigint(8)        not null
#  email           :string(255)      not null
#  password_digest :string(255)      not null
#  event           :string(255)      not null
#  created_at      :datetime
#

class UserChange < ApplicationRecord
  has_secure_password
  belongs_to :user, optional: true

  validates :email,           presence: true
  validates :password_digest, presence: true
end
