class AccessToken
	include Mongoid::Document
	include Mongoid::Timestamps

	belongs_to :user, :foreign_key => :user
	field :alias, type: String

	field :auth_token, type: String
	field :auth_secret, type: String
end