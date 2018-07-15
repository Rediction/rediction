class UserProfile < ApplicationRecord

  validates :last_name,         presence: true, length: {minimum: 1, maximum: 20}
  validates :last_name_kana,    presence: true, length: {minimum: 1, maximum: 20}
  validates :first_name,        presence: true, length: {minimum: 1, maximum: 20}
  validates :first_name_kana,   presence: true, length: {minimum: 1, maximum: 20}
  validates :birth_on           presence: true
  validates :job                presence: true
end