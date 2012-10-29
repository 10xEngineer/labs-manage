class User
	include Mongoid::Document
	include Mongoid::Timestamps

	include Sorcery::Model
  	include Sorcery::Model::Adapters::Mongoid

  	authenticates_with_sorcery!

	field :email, type: String
	field :name, type: String
	
	field :cpwd, type: String
	field :salt, type: String

	belongs_to :account, :foreign_key => :def_account

	field :service, type: Boolean, default: false
	field :disabled, type: Boolean, default: false
end