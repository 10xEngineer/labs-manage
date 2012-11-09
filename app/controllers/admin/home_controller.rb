class Admin::HomeController < Admin::BaseController
	def index
		@users = User.where(service: false).sort(created_at:-1).limit(10)
	end
end
