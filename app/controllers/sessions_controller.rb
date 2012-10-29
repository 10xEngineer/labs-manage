class SessionsController < ApplicationController
  def new
  	@user = User.new
  end

  def create

  end

  def destroy
  	logout

  	redirect_to root_path
  end
end
