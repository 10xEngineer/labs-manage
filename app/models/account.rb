user Account
	include Mongoid::Document
	include Mongoid::Timestamps

	field :handle, type: String

	# TODO owners

	field :disabled, type: Boolean, default: false
	field :organization, type: Boolean, default: false
end