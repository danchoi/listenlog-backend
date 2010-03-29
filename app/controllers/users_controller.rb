class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  def show
    @device_id = params[:id]
    endkey = [@device_id, nil]


    startkey = params[:startkeys] || [@device_id, {}] 
    logger.debug("Using startkey: #{startkey}")
    @limit = 21

    @res = Views.fetch("my_views/all_by_user_and_created_at", 
                       :startkey => startkey,
                       :endkey => endkey,
                       :limit => @limit,
                       :include_docs => true, :descending => true)
    @items = @res['rows']
    @total_rows = @res['total_rows']
    @offset = @res['offset']

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
