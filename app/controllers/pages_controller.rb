class PagesController < ApplicationController
  skip_before_action :authenticate, only: %i[privacy_policy terms_of_service]

  def privacy_policy
  end

  def terms_of_service
  end
end
