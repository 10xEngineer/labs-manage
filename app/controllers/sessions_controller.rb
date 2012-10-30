class SessionsController < ApplicationController
  layout nil

  def new
  	@user = User.new
  end

  def create

  	@user = login(params[:user][:email], params[:user][:password])

  	if @user
  		redirect_to user_path(@user._id)
  	else
  		# FIXME doesn't work
  		flash.now[:alert] = "Login failed"

  		@user = User.new
  		render :action => "new"
  	end
  end

  def destroy
  	logout

  	redirect_to root_path
  end
end
