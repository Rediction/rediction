class TimelinesController < ApplicationController

  def index
    @words = Word.all.order(:created_at)
  end
end
