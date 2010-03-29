class StreamsController < ApplicationController

  def index
    @device_id = params[:user_id]
    @res = Views.fetch("my_views/total_seconds_per_user_per_stream", 
                       :startkey => [@device_id, nil],
                       :endkey => [@device_id, {}],
                       :group => true)
    logger.debug @res.inspect
    @items = @res['rows']
  end

end
