class UserProfile < ApplicationRecord

  validates :last_name,         presence: true, length: { maximum: 20 }
  validates :last_name_kana,    presence: true, length: { maximum: 30 }
  validates :first_name,        presence: true, length: { maximum: 20 }
  validates :first_name_kana,   presence: true, length: { maximum: 30 }
  validates :birth_on           presence: true
  validates :job                presence: true
end