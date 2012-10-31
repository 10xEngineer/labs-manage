class AccessTokensController < ProtectedController
	def index
		@tokens = current_user.access_tokens
	end

	def generate
		AccessToken.generate(@current_user)

		redirect_to user_access_tokens_path(@current_user)
	end

private
	def rand_hexstring(length=8)
  		((0..length).map{rand(256).chr}*"").unpack("H*")[0][0,length]
	end
end
