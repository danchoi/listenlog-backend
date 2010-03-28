class StreamsController < ApplicationController
  def index
    @res = Views.fetch("my_views/total_seconds_per_stream", :group => true)
    logger.debug @res.inspect
    @items = @res['rows']
  end

end
