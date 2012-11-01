class HomeController < ProtectedController
	def index
		redirect_to user_path(@current_user)
	end
end
