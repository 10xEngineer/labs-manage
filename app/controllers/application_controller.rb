class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_authorization

  def check_authorization
  end
end
