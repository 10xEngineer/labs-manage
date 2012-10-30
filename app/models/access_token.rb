class AccessToken
	include Mongoid::Document
	include Mongoid::Timestamps

	belongs_to :user

	field :alias, type: String

	field :auth_token, type: String
	field :auth_secret, type: String

	field :deleted_at, type: Date, default: nil
end