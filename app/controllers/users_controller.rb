class UsersController < ProtectedController
	before_filter :require_login, :except => [:new, :create, :activate]
	before_filter :check_authorization, :except => [:new, :create, :activate]

	def index
		redirect user_path(@current_user)
	end

	def new
		@user = User.new

		render :new, :layout => 'sessions'
	end

	def create
		# TODO unique email
		@user = User.new(params[:user])

		# apply default limits
		# FIXME hardcoded default profile
		@profile = Profile.find_by(name: "beta_public")

		@user.limits = {}

		limited_resources = @profile.fields.reject {|f| ["_type","_id","created_at","updated_at", "name"].include?(f) }
		limited_resources.keys.each do |res|
			@user.limits[res] = @profile.send(res).to_i
		end

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

			$customerio.delay.identify(@user, name: @user.name)
			
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
