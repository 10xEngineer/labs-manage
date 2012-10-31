class UsersController < ProtectedController

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])

		if @user.save
			redirect_to root_path, :notice => "Signed up!"
		else
			render :new
		end
	end

	def show
		@user = User.find_by(id: params[:id])
	end
end
