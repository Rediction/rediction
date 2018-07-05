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

  has_secure_password validations: true
  belongs_to :user, foreign_key: 'user_id'

  validates :user_id,  presence: true
  validates :email,    presence: true
  validates :password, presence: true
end
