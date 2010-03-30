class ProgramsController < ApplicationController
  def index
    @device_id = params[:user_id]
    @res = Views.fetch("my_views/total_seconds_per_user_per_program", 
                       :startkey => [@device_id, nil],
                       :endkey => [@device_id, {}],
                       :group => true)

    @items = @res['rows']
    if iphone_client?
      render :layout => 'iphone', :template => "programs/index-iphone.html.erb"
    end
  end

end
