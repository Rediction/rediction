# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord

  has_secure_password validations: true

  validates :email,    presence: true, uniqueness: true
  validates :password, presence: true, uniqueness: true
end
