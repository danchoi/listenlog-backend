# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout 'application'

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def iphone_client?
    user_agent = request.env["HTTP_USER_AGENT"]
    user_agent =~ /iPhone/
  end
end
