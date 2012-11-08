class Admin::BaseController < ProtectedController
	before_filter :check_authorization

private

	def check_authorization
		unless @current_user.is_admin?
			redirect_to user_path(@current_user)
		end
	end
end
