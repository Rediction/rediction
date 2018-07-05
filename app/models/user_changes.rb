class User < ApplicationRecord

  validates :user_id,  {presence: true}
  validates :email,    {presence: true}
  validates :password, {presence: true}
end
