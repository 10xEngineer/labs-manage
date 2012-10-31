
def rand_hexstring(length=8)
		((0..length).map{rand(256).chr}*"").unpack("H*")[0][0,length]
end

class AccessToken
	include Mongoid::Document
	include Mongoid::Timestamps

	belongs_to :user

	field :alias, type: String

	field :auth_token, type: String
	field :auth_secret, type: String

	field :deleted_at, type: Date, default: nil

	def self.generate(user)
		current_token = AccessToken.where(user: user._id).first

		token = AccessToken.new(
			:user => user, 
			:alias => "default",
			:auth_token => rand_hexstring(29),
			:auth_secret => rand_hexstring(48)
			)

		if token.save
			current_token.destroy if current_token
		end
	end
end