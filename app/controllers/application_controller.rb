# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  skip_before_filter :verify_authenticity_token

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

end
