class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def save
    @provisional_user = ProvisionalUser.new(provisional_user_params)
    @provisional_user.verification_token = SecureRandom.uuid
    @provisional_user.save
  end

  private


    def provisional_user_params
      params.require(:provisional_user).permit(:email, :password)
    end
end
