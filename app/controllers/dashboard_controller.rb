class DashboardController < ProtectedController
	def index
		@tokens = current_user.access_tokens
	end
end
