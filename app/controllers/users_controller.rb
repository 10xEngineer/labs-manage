class UsersController < ProtectedController
	before_filter :require_login, :except => [:new, :create, :activate]
	before_filter :check_authorization, :except => [:new, :create, :activate]

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

			AccessToken.generate(@user)

			@user.account = @account
			@user.save

			redirect_to login_path, :notice => "Thank you for signing up for Labs! Check your email to finish the registration."
		else
			render :new, :layout => 'sessions'
		end
	end

	def activate
		if (@user = User.load_from_activation_token(params[:id]))
			@user.activate!
			redirect_to(login_path, :notice => 'User was successfully activated.')
	  	else
			not_authenticated
		end
	end


	def show
		@user = User.find_by(id: params[:id])

		if @user.keys.empty? 
			@ssh_reminder = true
		else
			@ssh_reminder = false
		end	
	end
end
