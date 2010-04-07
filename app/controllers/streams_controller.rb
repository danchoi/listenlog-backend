class StreamsController < ApplicationController

  def index
    @device_id = params[:user_id]
    @res = Views.fetch("my_views/total_seconds_per_user_per_stream", 
                       :startkey => [@device_id, nil],
                       :endkey => [@device_id, {}],
                       :group => true)
    
    @items = @res['rows']
    if iphone_client?
      render :layout => 'iphone'
    end
  end

end
