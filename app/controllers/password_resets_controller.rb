class PasswordResetsController < ApplicationController
	layout "sessions"
	skip_before_filter :require_login

	def new
		@user = User.new
	end

	def create
		@user = User.find_by_email(params[:user][:email])

		if @user
			@user.delay.deliver_reset_password_instructions!

			redirect_to login_path, :notice => "Instructions have been sent to your email."
		else
			@user = User.new
			render :action => :new
		end
	end

	def edit
 		@user = User.load_from_reset_password_token(params[:id])
    	@token = params[:id]
    	not_authenticated unless @user
	end

	def update
		@token = params[:user][:token]
		@user = User.load_from_reset_password_token(@token)
		not_authenticated unless @user
		# the next line makes the password confirmation validation work
		@user.password_confirmation = params[:user][:password_confirmation]
		# the next line clears the temporary token and updates the password
		if @user.change_password!(params[:user][:password])
		  redirect_to(login_path, :notice => 'Password was successfully updated.')
		else
		  render :action => "edit"
		 end
    end
end
