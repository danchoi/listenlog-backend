class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  # We're paginating the dumb way because smart pagination is complex in CouchDB
  # http://addywaddy.posterous.com/couchdb-and-pagination
  # http://books.couchdb.org/relax/receipts/pagination
  # We'll figure out the better way later
  def show
    @device_id = params[:id]
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

    

    logger.debug(@res.inspect)
    logger.debug("USER AGENT: #{request.env["HTTP_USER_AGENT"]}")
  end

  def index
  end

  # only json in the request
  def create
    user_doc = User.create_doc
    logger.debug("Create user: #{user_doc.inspect}")
    render :text => user_doc.to_json

  end
end
