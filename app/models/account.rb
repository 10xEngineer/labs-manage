class Account
	include Mongoid::Document
	include Mongoid::Timestamps

	field :handle, type: String
	field :account_ref, type: String

	# TODO owners

	field :disabled, type: Boolean, default: false
	field :organization, type: Boolean, default: false
end