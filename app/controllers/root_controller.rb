class RootController < ApplicationController
  skip_before_action :authenticate, only: %i[index]
  layout "root"

  def index
  end
end
