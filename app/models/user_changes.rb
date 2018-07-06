# == Schema Information
#
# Table name: user_changes
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  email      :bigint(8)
#  password   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserChanges < ApplicationRecord

  has_secure_password
  belongs_to :user

  validates :email,           presence: true
  validates :password_digest, presence: true
end
