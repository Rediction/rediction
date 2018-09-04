class ContactsController < ApplicationController
  skip_before_action :authenticate, only: %i[show]

  def show
  end
end
