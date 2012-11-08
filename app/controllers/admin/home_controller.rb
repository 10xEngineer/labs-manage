class Admin::HomeController < Admin::BaseController
	def index
		@users = User.all.sort(created_at:-1).limit(10)
	end
end
