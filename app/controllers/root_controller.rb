class RootController < ApplicationController
  skip_before_action :authenticate, only: %i[index]
  layout "root"

  def index
    redirect_authed_user_base_page if logged_in?
  end
end
