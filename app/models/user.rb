class User
	authenticates_with_sorcery!
	
	include Mongoid::Document
	include Mongoid::Timestamps

	field :email, type: String
	field :name, type: String
	
	field :cpwd, type: String
	field :salt, type: String

	# TODO def_account

	field :service, type: Boolean, default: false
	field :disabled, type: Boolean, default: false
end