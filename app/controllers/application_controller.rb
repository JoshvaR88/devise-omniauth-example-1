class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  before_filter { Rails.logger.info "\n\n #{env["omniauth.auth"].to_yaml}\n\n"}
  before_filter { Rails.logger.info "\n\n #{session.to_yaml}\n\n"}
end
