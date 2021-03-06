class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create


  def show
    if iphone_client?
      render :layout => 'iphone'
    end
  end

  def index
    @res = Views.fetch("my_views/total_seconds_per_user", 
                       :group => true,
                       :descending => true)
    @items = @res['rows']

    #logger.debug(@res.inspect)

    if iphone_client?
      render :layout => 'iphone'
    end
  end

  # only json in the request
  def create
    user_doc = User.create_doc
    logger.debug("Create user: #{user_doc.inspect}")
    render :text => user_doc.to_json
  end

  def export
    @device_id = params[:id]
    @startkey = [@device_id] 
    @endkey = [@device_id, {}]
    @res = Views.fetch("my_views/all_by_user_and_created_at", 
                       :startkey => @startkey,
                       :endkey => @endkey,
                       :include_docs => true)
    # this is inefficient; do a direct json extraction later
    respond_to do |format|
      format.json do 
        render :json  => @res['rows'].to_json
      end
    end
  end
end
