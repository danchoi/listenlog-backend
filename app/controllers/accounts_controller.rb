class AccountsController < ApplicationController

  def show
    @device_id = params[:user_id]
    render :layout => 'iphone', :template => 'accounts/show-iphone'
  end
end
