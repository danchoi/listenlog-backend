class ActivitiesController < ApplicationController
  # We're paginating the dumb way because smart pagination is complex in CouchDB
  # http://addywaddy.posterous.com/couchdb-and-pagination
  # http://books.couchdb.org/relax/receipts/pagination
  # We'll implement the better way later
  def show
    @device_id = params[:user_id]
    @limit = 10
    @offset = (params[:offset] || 0).to_i
    @endkey = [@device_id] 
    @startkey = params[:startkey] || [@device_id, {}]
    #logger.debug("Using startkey: #{startkey}")
    @res = Views.fetch("my_views/all_by_user_and_created_at", 
                       :startkey => @startkey,
                       :endkey => @endkey,
                       :skip => @offset,
                       :limit => @limit + 1,
                       :include_docs => true, :descending => true)
    @items = @res['rows']

    #logger.debug(@res.inspect)

    if iphone_client?
      render :layout => 'iphone'
    end
  end

  def authorize_delete
    @device_id = params[:user_id]

  end

  def destroy
    @device_id = params[:user_id]
    @pin = params[:pin]
    if User.authenticate(@device_id, @pin)
      res = User.new(@device_id).delete_activity
      flash[:notice] = "ListenLog deleted"
      redirect_to user_activity_url(:id => @device_id)
    else
      flash[:notice] = "Invalid PIN"
      redirect_to :action => 'authorize_delete', :user_id => @device_id
    end
  end

end
