class UsersController < ProtectedController
	before_filter :require_login, :except => [:new, :create]
	before_filter :check_authorization, :except => [:new, :create]

	def new
		@user = User.new

		render :new, :layout => 'sessions'
	end

	def create
		# TODO unique email
		@user = User.new(params[:user])

		if @user.save
			@account = Account.new
			@account.account_ref = Account.gen_reference
			@account.owners = [@user._id]
			@account.save

			@user.account = @account
			@user.save

			redirect_to root_path, :notice => "Signed up!"
		else
			render :new, :layout => 'sessions'
		end
	end

	def show
		@user = User.find_by(id: params[:id])
	end
end
