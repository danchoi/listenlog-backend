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
  end

  def index
  end

  # only json in the request
  def create
    payload = request.body.read
    user = User.new(payload)
    logger.debug("Create users; payload: #{payload.inspect}")
    logger.debug("Create users; payload parsed: #{payload.inspect}")
  end
end
