class SpyController < ApplicationController
  def index
    @res = Views.fetch("my_views/all_by_created_at", :include_docs => true, :descending => true)
    @items = @res['rows'].map {|x| x['doc']}
  end

  def update
    time = Time.at(params[:timestamp].to_i)
    # couch key is like "2010/03/11 14:39:07 +0000"
    #time_string = Time.now.utc.strftime("%Y/%m/%d %H:%M:%S +0000")
    time_string = (2.seconds.ago).utc.strftime("%Y/%m/%d %H:%M:%S +0000")
    logger.debug("Using timestring startkey: #{time_string}")

    @res = Views.fetch("my_views/all_by_created_at", :include_docs => true, :descending => false, :startkey => time_string)
    @items = @res['rows'].map {|x| x['doc']}

    logger.debug @items.inspect
    render :layout => false
  end
end
