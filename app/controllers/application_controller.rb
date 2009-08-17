# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :authenticate
  
  USER_NAME, PASSWORD = "gm", "testy"

  def authenticate
    #authenticate_or_request_with_http_basic do |user_name, password|
    #  user_name == USER_NAME && password == PASSWORD
    #end
  end
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
