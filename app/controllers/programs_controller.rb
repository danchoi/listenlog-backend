class ProgramsController < ApplicationController
  def index
    @res = Views.fetch("my_views/total_seconds_per_program", :group => true)
    logger.debug @res.inspect
    @items = @res['rows']
  end

end
