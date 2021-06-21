class PagesController < ApplicationController
  def archive
    @matches = Match.where(completed: true)
    # @matches = Match.all
  end
end
