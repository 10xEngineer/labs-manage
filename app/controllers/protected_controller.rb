class ProtectedController < ApplicationController
	before_filter :require_login
	before_filter :check_authorization

	def check_authorization
		params[:user_id] ? user_id = params[:user_id] : user_id = params[:id]

		unless user_id == @current_user._id.to_s
			render :status => 401, :file => "public/401.html"
		end
	end

private

	def not_authenticated
		redirect_to login_url
	end
end