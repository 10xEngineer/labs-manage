class AccessTokensController < ProtectedController
	def index
		@tokens = current_user.access_tokens
	end

	def generate
		# TODO move to model as helper function
		tokens = AccessToken.where(user: @current_user._id)
		old_token = tokens.first

		token = AccessToken.new(
			:user => @current_user, 
			:alias => "default",
			:auth_token => rand_hexstring(29),
			:auth_secret => rand_hexstring(48)
			)

		if token.save
			old_token.destroy if old_token
		end

		redirect_to user_access_tokens_path(@current_user)
	end

private
	def rand_hexstring(length=8)
  		((0..length).map{rand(256).chr}*"").unpack("H*")[0][0,length]
	end
end
